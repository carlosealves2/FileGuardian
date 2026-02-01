import 'package:guardian_ui/features/dashboard/data/models/process_model.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pb.dart'
    as pb;

class UploadProgressModel extends UploadProgressEntity {
  const UploadProgressModel({
    required super.processId,
    required super.uploadId,
    required super.filePath,
    required super.fileSize,
    required super.bytesUploaded,
    required super.status,
    super.errorMessage,
  });

  factory UploadProgressModel.fromProto(pb.UploadProgress proto) {
    return UploadProgressModel(
      processId: proto.processId,
      uploadId: proto.uploadId,
      filePath: proto.filePath,
      fileSize: proto.fileSize.toInt(),
      bytesUploaded: proto.bytesUploaded.toInt(),
      status: ProcessModel.mapStatus(proto.status),
      errorMessage:
          proto.errorMessage.isEmpty ? null : proto.errorMessage,
    );
  }
}
