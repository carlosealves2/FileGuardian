import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pb.dart'
    as pb;
import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pbenum.dart'
    as pb_enum;

class ProcessModel extends ProcessEntity {
  const ProcessModel({
    required super.id,
    required super.type,
    required super.status,
    required super.provider,
    required super.sourcePath,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProcessModel.fromProto(pb.Process proto) {
    return ProcessModel(
      id: proto.id,
      type: mapType(proto.type),
      status: mapStatus(proto.status),
      provider: proto.provider,
      sourcePath: proto.sourcePath,
      createdAt: proto.createdAt.toDateTime(),
      updatedAt: proto.updatedAt.toDateTime(),
    );
  }

  static ProcessType mapType(pb_enum.ProcessType protoType) {
    return switch (protoType) {
      pb_enum.ProcessType.PROCESS_TYPE_FOLDER => ProcessType.folder,
      _ => ProcessType.file,
    };
  }

  static ProcessStatus mapStatus(pb_enum.Status protoStatus) {
    return switch (protoStatus) {
      pb_enum.Status.STATUS_IN_PROGRESS => ProcessStatus.inProgress,
      pb_enum.Status.STATUS_PAUSED => ProcessStatus.paused,
      pb_enum.Status.STATUS_COMPLETED => ProcessStatus.completed,
      pb_enum.Status.STATUS_FAILED => ProcessStatus.failed,
      pb_enum.Status.STATUS_CANCELLED => ProcessStatus.cancelled,
      _ => ProcessStatus.pending,
    };
  }
}
