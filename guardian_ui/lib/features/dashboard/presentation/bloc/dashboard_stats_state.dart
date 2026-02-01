import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/recent_backup_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/scheduled_backup_entity.dart';

sealed class DashboardStatsState extends Equatable {
  const DashboardStatsState();

  @override
  List<Object?> get props => [];
}

class DashboardStatsInitial extends DashboardStatsState {
  const DashboardStatsInitial();
}

class DashboardStatsLoading extends DashboardStatsState {
  const DashboardStatsLoading();
}

class DashboardStatsLoaded extends DashboardStatsState {
  final DashboardStatsEntity stats;
  final List<RecentBackupEntity> recentBackups;
  final List<ScheduledBackupEntity> scheduledBackups;

  const DashboardStatsLoaded({
    required this.stats,
    required this.recentBackups,
    required this.scheduledBackups,
  });

  @override
  List<Object?> get props => [stats, recentBackups, scheduledBackups];
}

class DashboardStatsError extends DashboardStatsState {
  final String message;

  const DashboardStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
