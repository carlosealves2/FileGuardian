import 'package:equatable/equatable.dart';

class ConfigEntity extends Equatable {
  final String activeProvider;
  final int uploadPartSize;
  final int uploadMaxConcurrent;
  final int grpcPort;

  const ConfigEntity({
    required this.activeProvider,
    required this.uploadPartSize,
    required this.uploadMaxConcurrent,
    required this.grpcPort,
  });

  @override
  List<Object?> get props => [
        activeProvider,
        uploadPartSize,
        uploadMaxConcurrent,
        grpcPort,
      ];
}
