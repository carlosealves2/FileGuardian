import 'package:guardian_ui/features/dashboard/data/models/process_model.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pb.dart'
    as pb;

class UploadModel extends UploadEntity {
  const UploadModel({
    required super.id,
    required super.processId,
    required super.filePath,
    required super.storageKey,
    required super.fileSize,
    required super.bytesUploaded,
    required super.status,
    super.errorMessage,
    super.checksum,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UploadModel.fromProto(pb.Upload proto) {
    return UploadModel(
      id: proto.id,
      processId: proto.processId,
      filePath: proto.filePath,
      storageKey: proto.storageKey,
      fileSize: proto.fileSize.toInt(),
      bytesUploaded: proto.bytesUploaded.toInt(),
      status: ProcessModel.mapStatus(proto.status),
      errorMessage:
          proto.errorMessage.isEmpty ? null : proto.errorMessage,
      checksum: proto.checksum.isEmpty ? null : proto.checksum,
      createdAt: proto.createdAt.toDateTime(),
      updatedAt: proto.updatedAt.toDateTime(),
    );
  }
}
