import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/core/di/injection.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/dashboard_stats_cubit.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/current_backup_card.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/recent_backups_card.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/scheduled_backups_card.dart';
import 'package:guardian_ui/features/dashboard/presentation/widgets/stats_cards_row.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardStatsCubit>()..loadStats(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 24),
            const StatsCardsRow(),
            const SizedBox(height: 24),
            const CurrentBackupCard(),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return const Column(
                    children: [
                      RecentBackupsCard(),
                      SizedBox(height: 24),
                      ScheduledBackupsCard(),
                    ],
                  );
                }

                return const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: RecentBackupsCard()),
                      SizedBox(width: 24),
                      Expanded(child: ScheduledBackupsCard()),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
