import 'package:flutter/material.dart';

import 'package:guardian_ui/core/theme/status_colors.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/status_badge.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';

class UploadProgressCard extends StatelessWidget {
  final UploadEntity upload;

  const UploadProgressCard({super.key, required this.upload});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColors = theme.extension<StatusColors>()!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: upload.status),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: upload.progress,
                minHeight: 6,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                color: _progressColor(statusColors),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatBytes(upload.bytesUploaded)} / ${_formatBytes(upload.fileSize)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${(upload.progress * 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (upload.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                upload.errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _fileName {
    final parts = upload.filePath.split('/');
    return parts.isNotEmpty ? parts.last : upload.filePath;
  }

  Color _progressColor(StatusColors colors) {
    return switch (upload.status) {
      ProcessStatus.completed => colors.completed,
      ProcessStatus.failed => colors.failed,
      ProcessStatus.paused => colors.paused,
      _ => colors.inProgress,
    };
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
