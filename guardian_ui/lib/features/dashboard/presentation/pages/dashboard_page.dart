import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_state.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/empty_state.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/process_list_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProcessListBloc>();
    if (bloc.state is ProcessListInitial) {
      bloc.add(const ProcessListLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
        actions: [
          _UploadMenuButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            const _UploadProgressBar(),
            Expanded(
              child: BlocBuilder<ProcessListBloc, ProcessListState>(
                builder: (context, state) {
                  return switch (state) {
                    ProcessListInitial() ||
                    ProcessListLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    ProcessListError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<ProcessListBloc>()
                            .add(const ProcessListLoadRequested()),
                      ),
                    ProcessListLoaded() => _ProcessList(state: state),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.insert_drive_file_outlined),
          onPressed: () => _pickFile(context),
          child: const Text('Upload File'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.folder_outlined),
          onPressed: () => _pickFolder(context),
          child: const Text('Upload Folder'),
        ),
      ],
      builder: (context, controller, child) {
        return FilledButton.icon(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.upload_outlined),
          label: const Text('Upload'),
        );
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    if (!context.mounted) return;

    final path = result.files.single.path;
    if (path == null) return;

    context.read<UploadBloc>().add(UploadFileRequested(filePath: path));
  }

  Future<void> _pickFolder(BuildContext context) async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    if (!context.mounted) return;

    context.read<UploadBloc>().add(UploadFolderRequested(folderPath: path));
  }
}

class _UploadProgressBar extends StatelessWidget {
  const _UploadProgressBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadBloc, UploadState>(
      builder: (context, state) {
        if (state is! UploadInProgress) return const SizedBox.shrink();
        if (state.progressByUploadId.isEmpty) return const SizedBox.shrink();

        return LinearProgressIndicator(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
        );
      },
    );
  }
}

class _ProcessList extends StatelessWidget {
  final ProcessListLoaded state;

  const _ProcessList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.processes.isEmpty) {
      return const EmptyState(
        icon: Icons.cloud_upload_outlined,
        title: 'No processes yet',
        subtitle: 'Upload a file or folder to get started.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ProcessListBloc>()
            .add(const ProcessListRefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: state.processes.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.processes.length) {
            _loadMore(context);
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ProcessListTile(process: state.processes[index]),
          );
        },
      ),
    );
  }

  void _loadMore(BuildContext context) {
    if (!state.isLoadingMore) {
      context
          .read<ProcessListBloc>()
          .add(const ProcessListNextPageRequested());
    }
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
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
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
