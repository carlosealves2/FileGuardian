import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';

class UploadEntity extends Equatable {
  final String id;
  final String processId;
  final String filePath;
  final String storageKey;
  final int fileSize;
  final int bytesUploaded;
  final ProcessStatus status;
  final String? errorMessage;
  final String? checksum;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UploadEntity({
    required this.id,
    required this.processId,
    required this.filePath,
    required this.storageKey,
    required this.fileSize,
    required this.bytesUploaded,
    required this.status,
    this.errorMessage,
    this.checksum,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progress => fileSize > 0 ? bytesUploaded / fileSize : 0;

  @override
  List<Object?> get props => [
        id,
        processId,
        filePath,
        storageKey,
        fileSize,
        bytesUploaded,
        status,
        errorMessage,
        checksum,
        createdAt,
        updatedAt,
      ];
}
