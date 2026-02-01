import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/scheduled_backup_entity.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_cubit.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_state.dart';

class ScheduledBackupsCard extends StatelessWidget {
  const ScheduledBackupsCard({super.key});

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
                Text(
                  'Scheduled Backups',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Add New'),
                ),
              ],
            ),
            const Divider(height: 16),
            BlocBuilder<DashboardStatsCubit, DashboardStatsState>(
              builder: (context, state) {
                if (state is! DashboardStatsLoaded) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: state.scheduledBackups
                      .map((schedule) => _ScheduledBackupTile(schedule: schedule))
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

class _ScheduledBackupTile extends StatelessWidget {
  final ScheduledBackupEntity schedule;

  const _ScheduledBackupTile({required this.schedule});

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
              Icons.schedule,
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
                  schedule.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${schedule.schedule} - ${schedule.nextRunLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: schedule.enabled,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
