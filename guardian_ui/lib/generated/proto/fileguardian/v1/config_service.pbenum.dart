// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/config_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// FieldType defines the data type of a provider configuration field.
class FieldType extends $pb.ProtobufEnum {
  static const FieldType FIELD_TYPE_UNSPECIFIED =
      FieldType._(0, _omitEnumNames ? '' : 'FIELD_TYPE_UNSPECIFIED');
  static const FieldType FIELD_TYPE_STRING =
      FieldType._(1, _omitEnumNames ? '' : 'FIELD_TYPE_STRING');
  static const FieldType FIELD_TYPE_SECRET =
      FieldType._(2, _omitEnumNames ? '' : 'FIELD_TYPE_SECRET');
  static const FieldType FIELD_TYPE_NUMBER =
      FieldType._(3, _omitEnumNames ? '' : 'FIELD_TYPE_NUMBER');
  static const FieldType FIELD_TYPE_BOOLEAN =
      FieldType._(4, _omitEnumNames ? '' : 'FIELD_TYPE_BOOLEAN');

  static const $core.List<FieldType> values = <FieldType>[
    FIELD_TYPE_UNSPECIFIED,
    FIELD_TYPE_STRING,
    FIELD_TYPE_SECRET,
    FIELD_TYPE_NUMBER,
    FIELD_TYPE_BOOLEAN,
  ];

  static final $core.List<FieldType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FieldType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
