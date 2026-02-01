import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/config_service.pb.dart';

class ConfigModel extends ConfigEntity {
  const ConfigModel({
    required super.activeProvider,
    required super.uploadPartSize,
    required super.uploadMaxConcurrent,
    required super.grpcPort,
  });

  factory ConfigModel.fromProto(GetConfigResponse proto) {
    return ConfigModel(
      activeProvider: proto.activeProvider,
      uploadPartSize: proto.uploadPartSize.toInt(),
      uploadMaxConcurrent: proto.uploadMaxConcurrent,
      grpcPort: proto.grpcPort,
    );
  }
}
