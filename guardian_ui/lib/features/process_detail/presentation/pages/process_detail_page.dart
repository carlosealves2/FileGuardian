import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:guardian_ui/core/di/injection.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/status_badge.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_bloc.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_event.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_state.dart';
import 'package:guardian_ui/features/process_detail/presentation/widgets/process_action_buttons.dart';
import 'package:guardian_ui/features/process_detail/presentation/widgets/upload_progress_card.dart';

class ProcessDetailPage extends StatelessWidget {
  final String processId;

  const ProcessDetailPage({super.key, required this.processId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProcessDetailBloc>(param1: processId)
        ..add(const ProcessDetailLoadRequested()),
      child: const _ProcessDetailView(),
    );
  }
}

class _ProcessDetailView extends StatelessWidget {
  const _ProcessDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessDetailBloc, ProcessDetailState>(
      listener: (context, state) {
        if (state is ProcessDetailLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionError!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
              tooltip: 'Back to Dashboard',
            ),
            title: Text(
              state is ProcessDetailLoaded
                  ? _titleFromPath(state.process.sourcePath)
                  : 'Process Detail',
            ),
            actions: [
              if (state is ProcessDetailLoaded)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ProcessActionButtons(
                    status: state.process.status,
                    onPause: () => context
                        .read<ProcessDetailBloc>()
                        .add(const ProcessDetailPauseRequested()),
                    onResume: () => context
                        .read<ProcessDetailBloc>()
                        .add(const ProcessDetailResumeRequested()),
                    onCancel: () => _confirmCancel(context),
                  ),
                ),
            ],
          ),
          body: switch (state) {
            ProcessDetailInitial() ||
            ProcessDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProcessDetailError(:final message) => _ErrorView(
                message: message,
                onRetry: () => context
                    .read<ProcessDetailBloc>()
                    .add(const ProcessDetailLoadRequested()),
              ),
            ProcessDetailLoaded() => _LoadedView(state: state),
          },
        );
      },
    );
  }

  String _titleFromPath(String path) {
    final parts = path.split('/');
    return parts.isNotEmpty ? parts.last : path;
  }

  void _confirmCancel(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Process'),
        content: const Text(
          'Are you sure you want to cancel this process? '
          'This will abort all uploads and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ProcessDetailBloc>()
                  .add(const ProcessDetailCancelRequested());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cancel Process'),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final ProcessDetailLoaded state;

  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final process = state.process;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          process.type == ProcessType.folder
                              ? Icons.folder_outlined
                              : Icons.insert_drive_file_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            process.sourcePath,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusBadge(status: process.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Provider: ${process.provider}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Created: ${_formatDate(process.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Uploads (${state.uploads.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...state.uploads.map((upload) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: UploadProgressCard(upload: upload),
                )),
            if (state.uploads.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No uploads found for this process.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
