import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_field_entity.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/config_service.pb.dart'
    as pb;
import 'package:guardian_ui/generated/proto/fileguardian/v1/config_service.pbenum.dart'
    as pb_enum;

class ProviderModel extends ProviderEntity {
  const ProviderModel({
    required super.name,
    required super.displayName,
    required super.active,
    required super.fields,
  });

  factory ProviderModel.fromProto(pb.Provider proto) {
    return ProviderModel(
      name: proto.name,
      displayName: proto.displayName,
      active: proto.active,
      fields: proto.fields.map(ProviderFieldModel.fromProto).toList(),
    );
  }
}

class ProviderFieldModel extends ProviderFieldEntity {
  const ProviderFieldModel({
    required super.key,
    required super.label,
    required super.type,
    required super.required,
    required super.value,
    required super.placeholder,
  });

  factory ProviderFieldModel.fromProto(pb.ProviderField proto) {
    return ProviderFieldModel(
      key: proto.key,
      label: proto.label,
      type: _mapFieldType(proto.type),
      required: proto.required,
      value: proto.value,
      placeholder: proto.placeholder,
    );
  }

  static FieldType _mapFieldType(pb_enum.FieldType protoType) {
    return switch (protoType) {
      pb_enum.FieldType.FIELD_TYPE_SECRET => FieldType.secret,
      pb_enum.FieldType.FIELD_TYPE_NUMBER => FieldType.number,
      pb_enum.FieldType.FIELD_TYPE_BOOLEAN => FieldType.boolean,
      _ => FieldType.string,
    };
  }
}
