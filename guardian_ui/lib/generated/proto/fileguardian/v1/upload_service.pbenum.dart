// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/upload_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ProcessType indicates whether the process is a single file or folder upload.
class ProcessType extends $pb.ProtobufEnum {
  static const ProcessType PROCESS_TYPE_UNSPECIFIED =
      ProcessType._(0, _omitEnumNames ? '' : 'PROCESS_TYPE_UNSPECIFIED');
  static const ProcessType PROCESS_TYPE_FILE =
      ProcessType._(1, _omitEnumNames ? '' : 'PROCESS_TYPE_FILE');
  static const ProcessType PROCESS_TYPE_FOLDER =
      ProcessType._(2, _omitEnumNames ? '' : 'PROCESS_TYPE_FOLDER');

  static const $core.List<ProcessType> values = <ProcessType>[
    PROCESS_TYPE_UNSPECIFIED,
    PROCESS_TYPE_FILE,
    PROCESS_TYPE_FOLDER,
  ];

  static final $core.List<ProcessType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ProcessType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProcessType._(super.value, super.name);
}

/// Status represents the current state of a process or upload.
class Status extends $pb.ProtobufEnum {
  static const Status STATUS_UNSPECIFIED =
      Status._(0, _omitEnumNames ? '' : 'STATUS_UNSPECIFIED');
  static const Status STATUS_PENDING =
      Status._(1, _omitEnumNames ? '' : 'STATUS_PENDING');
  static const Status STATUS_IN_PROGRESS =
      Status._(2, _omitEnumNames ? '' : 'STATUS_IN_PROGRESS');
  static const Status STATUS_PAUSED =
      Status._(3, _omitEnumNames ? '' : 'STATUS_PAUSED');
  static const Status STATUS_COMPLETED =
      Status._(4, _omitEnumNames ? '' : 'STATUS_COMPLETED');
  static const Status STATUS_FAILED =
      Status._(5, _omitEnumNames ? '' : 'STATUS_FAILED');
  static const Status STATUS_CANCELLED =
      Status._(6, _omitEnumNames ? '' : 'STATUS_CANCELLED');

  static const $core.List<Status> values = <Status>[
    STATUS_UNSPECIFIED,
    STATUS_PENDING,
    STATUS_IN_PROGRESS,
    STATUS_PAUSED,
    STATUS_COMPLETED,
    STATUS_FAILED,
    STATUS_CANCELLED,
  ];

  static final $core.List<Status?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Status? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Status._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
