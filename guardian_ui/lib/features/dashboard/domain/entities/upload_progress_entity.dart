import 'package:equatable/equatable.dart';

import 'process_entity.dart';

class UploadProgressEntity extends Equatable {
  final String processId;
  final String uploadId;
  final String filePath;
  final int fileSize;
  final int bytesUploaded;
  final ProcessStatus status;
  final String? errorMessage;

  const UploadProgressEntity({
    required this.processId,
    required this.uploadId,
    required this.filePath,
    required this.fileSize,
    required this.bytesUploaded,
    required this.status,
    this.errorMessage,
  });

  double get progress => fileSize > 0 ? bytesUploaded / fileSize : 0;

  @override
  List<Object?> get props => [
        processId,
        uploadId,
        filePath,
        fileSize,
        bytesUploaded,
        status,
        errorMessage,
      ];
}
