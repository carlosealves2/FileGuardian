import 'package:flutter/material.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/recent_backup_entity.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/status_badge.dart';

class RecentBackupTile extends StatelessWidget {
  final RecentBackupEntity backup;

  const RecentBackupTile({super.key, required this.backup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.folder_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${backup.sizeLabel} - ${backup.timeAgoLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(status: backup.status),
        ],
      ),
    );
  }
}
