import 'package:equatable/equatable.dart';

enum ProcessType { file, folder }

enum ProcessStatus {
  pending,
  inProgress,
  paused,
  completed,
  failed,
  cancelled,
}

class ProcessEntity extends Equatable {
  final String id;
  final ProcessType type;
  final ProcessStatus status;
  final String provider;
  final String sourcePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProcessEntity({
    required this.id,
    required this.type,
    required this.status,
    required this.provider,
    required this.sourcePath,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        status,
        provider,
        sourcePath,
        createdAt,
        updatedAt,
      ];
}
