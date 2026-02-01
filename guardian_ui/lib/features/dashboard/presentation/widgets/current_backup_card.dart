import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/core/format/byte_formatter.dart';
import 'package:guardian_ui/core/theme/status_colors.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';

class CurrentBackupCard extends StatelessWidget {
  const CurrentBackupCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Backup',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<UploadBloc, UploadState>(
              builder: (context, state) {
                if (state is! UploadInProgress ||
                    state.progressByUploadId.isEmpty) {
                  return _NoActiveBackup();
                }

                return Column(
                  children: state.progressByUploadId.values
                      .map((progress) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _UploadProgressTile(progress: progress),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NoActiveBackup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No active backup in progress',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _UploadProgressTile extends StatelessWidget {
  final UploadProgressEntity progress;

  const _UploadProgressTile({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColors = theme.extension<StatusColors>()!;
    final fileName = progress.filePath.split('/').last;
    final isPaused = progress.status == ProcessStatus.paused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fileName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(progress.progress * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            if (progress.status == ProcessStatus.inProgress ||
                progress.status == ProcessStatus.paused)
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  onPressed: () => _togglePause(context),
                  icon: Icon(
                    isPaused ? Icons.play_arrow : Icons.pause,
                    size: 16,
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: isPaused ? 'Resume' : 'Pause',
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: _progressColor(statusColors),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatBytes(progress.bytesUploaded)} / ${formatBytes(progress.fileSize)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _progressColor(StatusColors colors) {
    return switch (progress.status) {
      ProcessStatus.completed => colors.completed,
      ProcessStatus.failed => colors.failed,
      ProcessStatus.paused => colors.paused,
      _ => colors.inProgress,
    };
  }

  void _togglePause(BuildContext context) {
    final bloc = context.read<UploadBloc>();
    if (progress.status == ProcessStatus.paused) {
      bloc.add(UploadResumeRequested(processId: progress.processId));
    } else {
      bloc.add(UploadPauseRequested(processId: progress.processId));
    }
  }
}
