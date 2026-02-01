import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_cubit.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_state.dart';

import 'stats_card.dart';

class StatsCardsRow extends StatelessWidget {
  const StatsCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardStatsCubit, DashboardStatsState>(
      builder: (context, state) {
        if (state is! DashboardStatsLoaded) {
          return const SizedBox.shrink();
        }

        final stats = state.stats;

        return Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.backup,
                iconColor: const Color(0xFF42A5F5),
                label: 'Total Backups',
                value: '${stats.totalBackups}',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                icon: Icons.access_time,
                iconColor: const Color(0xFF66BB6A),
                label: 'Last Backup',
                value: stats.lastBackupAge,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFFFFA726),
                label: 'Success Rate',
                value: '${stats.successRate}%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                icon: Icons.storage,
                iconColor: const Color(0xFFAB47BC),
                label: 'Storage Used',
                value: '${stats.storageUsedGB.toStringAsFixed(0)} GB',
              ),
            ),
          ],
        );
      },
    );
  }
}
