import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final int totalBackups;
  final String lastBackupAge;
  final double successRate;
  final double storageUsedGB;

  const DashboardStatsEntity({
    required this.totalBackups,
    required this.lastBackupAge,
    required this.successRate,
    required this.storageUsedGB,
  });

  @override
  List<Object?> get props => [
        totalBackups,
        lastBackupAge,
        successRate,
        storageUsedGB,
      ];
}
