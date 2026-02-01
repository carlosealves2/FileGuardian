import 'package:equatable/equatable.dart';

class ScheduledBackupEntity extends Equatable {
  final String id;
  final String name;
  final String schedule;
  final String nextRunLabel;
  final bool enabled;

  const ScheduledBackupEntity({
    required this.id,
    required this.name,
    required this.schedule,
    required this.nextRunLabel,
    required this.enabled,
  });

  @override
  List<Object?> get props => [id, name, schedule, nextRunLabel, enabled];
}
