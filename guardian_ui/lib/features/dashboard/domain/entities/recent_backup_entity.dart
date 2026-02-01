import 'package:equatable/equatable.dart';

import 'process_entity.dart';

class RecentBackupEntity extends Equatable {
  final String id;
  final String name;
  final String sizeLabel;
  final String timeAgoLabel;
  final ProcessStatus status;

  const RecentBackupEntity({
    required this.id,
    required this.name,
    required this.sizeLabel,
    required this.timeAgoLabel,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, sizeLabel, timeAgoLabel, status];
}
