import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/recent_backup_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/scheduled_backup_entity.dart';

import 'dashboard_stats_state.dart';

class DashboardStatsCubit extends Cubit<DashboardStatsState> {
  DashboardStatsCubit() : super(const DashboardStatsInitial());

  void loadStats() {
    emit(const DashboardStatsLoading());

    // Mock data — replace with real use case when backend supports it
    const stats = DashboardStatsEntity(
      totalBackups: 156,
      lastBackupAge: '2h ago',
      successRate: 98.7,
      storageUsedGB: 245,
    );

    const recentBackups = [
      RecentBackupEntity(
        id: '1',
        name: 'Documents',
        sizeLabel: '2.4 GB',
        timeAgoLabel: '2 hours ago',
        status: ProcessStatus.completed,
      ),
      RecentBackupEntity(
        id: '2',
        name: 'Photos',
        sizeLabel: '15.2 GB',
        timeAgoLabel: '5 hours ago',
        status: ProcessStatus.completed,
      ),
      RecentBackupEntity(
        id: '3',
        name: 'Desktop',
        sizeLabel: '890 MB',
        timeAgoLabel: '1 day ago',
        status: ProcessStatus.failed,
      ),
      RecentBackupEntity(
        id: '4',
        name: 'Downloads',
        sizeLabel: '4.1 GB',
        timeAgoLabel: '2 days ago',
        status: ProcessStatus.completed,
      ),
      RecentBackupEntity(
        id: '5',
        name: 'Videos',
        sizeLabel: '32.5 GB',
        timeAgoLabel: '3 days ago',
        status: ProcessStatus.completed,
      ),
    ];

    const scheduledBackups = [
      ScheduledBackupEntity(
        id: '1',
        name: 'Daily Backup',
        schedule: 'Every day at 2:00 AM',
        nextRunLabel: 'In 8 hours',
        enabled: true,
      ),
      ScheduledBackupEntity(
        id: '2',
        name: 'Weekly Backup',
        schedule: 'Every Sunday at 3:00 AM',
        nextRunLabel: 'In 3 days',
        enabled: true,
      ),
      ScheduledBackupEntity(
        id: '3',
        name: 'Monthly Backup',
        schedule: '1st of every month at 1:00 AM',
        nextRunLabel: 'In 28 days',
        enabled: false,
      ),
    ];

    emit(const DashboardStatsLoaded(
      stats: stats,
      recentBackups: recentBackups,
      scheduledBackups: scheduledBackups,
    ));
  }
}
