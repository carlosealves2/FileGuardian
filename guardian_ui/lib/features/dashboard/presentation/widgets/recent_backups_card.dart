import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_cubit.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_state.dart';

import 'recent_backup_tile.dart';

class RecentBackupsCard extends StatelessWidget {
  const RecentBackupsCard({super.key});

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
                  'Recent Backups',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
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
                  children: state.recentBackups
                      .map((backup) => RecentBackupTile(backup: backup))
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
