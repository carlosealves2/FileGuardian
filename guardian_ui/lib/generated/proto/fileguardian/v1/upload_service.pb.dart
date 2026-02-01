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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'upload_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'upload_service.pbenum.dart';

class UploadFileRequest extends $pb.GeneratedMessage {
  factory UploadFileRequest({
    $core.String? filePath,
  }) {
    final result = create();
    if (filePath != null) result.filePath = filePath;
    return result;
  }

  UploadFileRequest._();

  factory UploadFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadFileRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) =>
      super.copyWith((message) => updates(message as UploadFileRequest))
          as UploadFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFileRequest create() => UploadFileRequest._();
  @$core.override
  UploadFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadFileRequest>(create);
  static UploadFileRequest? _defaultInstance;

  /// Absolute path to the file on the local filesystem.
  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => $_clearField(1);
}

/// UploadFileResponse streams progress updates for a single file upload.
class UploadFileResponse extends $pb.GeneratedMessage {
  factory UploadFileResponse({
    UploadProgress? progress,
  }) {
    final result = create();
    if (progress != null) result.progress = progress;
    return result;
  }

  UploadFileResponse._();

  factory UploadFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadFileResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOM<UploadProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: UploadProgress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFileResponse copyWith(void Function(UploadFileResponse) updates) =>
      super.copyWith((message) => updates(message as UploadFileResponse))
          as UploadFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFileResponse create() => UploadFileResponse._();
  @$core.override
  UploadFileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadFileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadFileResponse>(create);
  static UploadFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UploadProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(UploadProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  UploadProgress ensureProgress() => $_ensure(0);
}

class UploadFolderRequest extends $pb.GeneratedMessage {
  factory UploadFolderRequest({
    $core.String? folderPath,
  }) {
    final result = create();
    if (folderPath != null) result.folderPath = folderPath;
    return result;
  }

  UploadFolderRequest._();

  factory UploadFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadFolderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFolderRequest copyWith(void Function(UploadFolderRequest) updates) =>
      super.copyWith((message) => updates(message as UploadFolderRequest))
          as UploadFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFolderRequest create() => UploadFolderRequest._();
  @$core.override
  UploadFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadFolderRequest>(create);
  static UploadFolderRequest? _defaultInstance;

  /// Absolute path to the folder on the local filesystem.
  @$pb.TagNumber(1)
  $core.String get folderPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderPath() => $_clearField(1);
}

/// UploadFolderResponse streams progress updates for a folder upload.
class UploadFolderResponse extends $pb.GeneratedMessage {
  factory UploadFolderResponse({
    UploadProgress? progress,
  }) {
    final result = create();
    if (progress != null) result.progress = progress;
    return result;
  }

  UploadFolderResponse._();

  factory UploadFolderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadFolderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadFolderResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOM<UploadProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: UploadProgress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFolderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFolderResponse copyWith(void Function(UploadFolderResponse) updates) =>
      super.copyWith((message) => updates(message as UploadFolderResponse))
          as UploadFolderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFolderResponse create() => UploadFolderResponse._();
  @$core.override
  UploadFolderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadFolderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadFolderResponse>(create);
  static UploadFolderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UploadProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(UploadProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  UploadProgress ensureProgress() => $_ensure(0);
}

class PauseProcessRequest extends $pb.GeneratedMessage {
  factory PauseProcessRequest({
    $core.String? processId,
  }) {
    final result = create();
    if (processId != null) result.processId = processId;
    return result;
  }

  PauseProcessRequest._();

  factory PauseProcessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PauseProcessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseProcessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'processId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseProcessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseProcessRequest copyWith(void Function(PauseProcessRequest) updates) =>
      super.copyWith((message) => updates(message as PauseProcessRequest))
          as PauseProcessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PauseProcessRequest create() => PauseProcessRequest._();
  @$core.override
  PauseProcessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PauseProcessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseProcessRequest>(create);
  static PauseProcessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processId => $_getSZ(0);
  @$pb.TagNumber(1)
  set processId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessId() => $_clearField(1);
}

class PauseProcessResponse extends $pb.GeneratedMessage {
  factory PauseProcessResponse() => create();

  PauseProcessResponse._();

  factory PauseProcessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PauseProcessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseProcessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseProcessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseProcessResponse copyWith(void Function(PauseProcessResponse) updates) =>
      super.copyWith((message) => updates(message as PauseProcessResponse))
          as PauseProcessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PauseProcessResponse create() => PauseProcessResponse._();
  @$core.override
  PauseProcessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PauseProcessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseProcessResponse>(create);
  static PauseProcessResponse? _defaultInstance;
}

class ResumeProcessRequest extends $pb.GeneratedMessage {
  factory ResumeProcessRequest({
    $core.String? processId,
  }) {
    final result = create();
    if (processId != null) result.processId = processId;
    return result;
  }

  ResumeProcessRequest._();

  factory ResumeProcessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeProcessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeProcessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'processId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeProcessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeProcessRequest copyWith(void Function(ResumeProcessRequest) updates) =>
      super.copyWith((message) => updates(message as ResumeProcessRequest))
          as ResumeProcessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeProcessRequest create() => ResumeProcessRequest._();
  @$core.override
  ResumeProcessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeProcessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeProcessRequest>(create);
  static ResumeProcessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processId => $_getSZ(0);
  @$pb.TagNumber(1)
  set processId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessId() => $_clearField(1);
}

/// ResumeProcessResponse streams progress updates for a resumed process.
class ResumeProcessResponse extends $pb.GeneratedMessage {
  factory ResumeProcessResponse({
    UploadProgress? progress,
  }) {
    final result = create();
    if (progress != null) result.progress = progress;
    return result;
  }

  ResumeProcessResponse._();

  factory ResumeProcessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeProcessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeProcessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOM<UploadProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: UploadProgress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeProcessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeProcessResponse copyWith(
          void Function(ResumeProcessResponse) updates) =>
      super.copyWith((message) => updates(message as ResumeProcessResponse))
          as ResumeProcessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeProcessResponse create() => ResumeProcessResponse._();
  @$core.override
  ResumeProcessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeProcessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeProcessResponse>(create);
  static ResumeProcessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UploadProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(UploadProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  UploadProgress ensureProgress() => $_ensure(0);
}

class CancelProcessRequest extends $pb.GeneratedMessage {
  factory CancelProcessRequest({
    $core.String? processId,
  }) {
    final result = create();
    if (processId != null) result.processId = processId;
    return result;
  }

  CancelProcessRequest._();

  factory CancelProcessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelProcessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelProcessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'processId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelProcessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelProcessRequest copyWith(void Function(CancelProcessRequest) updates) =>
      super.copyWith((message) => updates(message as CancelProcessRequest))
          as CancelProcessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelProcessRequest create() => CancelProcessRequest._();
  @$core.override
  CancelProcessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelProcessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelProcessRequest>(create);
  static CancelProcessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processId => $_getSZ(0);
  @$pb.TagNumber(1)
  set processId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessId() => $_clearField(1);
}

class CancelProcessResponse extends $pb.GeneratedMessage {
  factory CancelProcessResponse() => create();

  CancelProcessResponse._();

  factory CancelProcessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelProcessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelProcessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelProcessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelProcessResponse copyWith(
          void Function(CancelProcessResponse) updates) =>
      super.copyWith((message) => updates(message as CancelProcessResponse))
          as CancelProcessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelProcessResponse create() => CancelProcessResponse._();
  @$core.override
  CancelProcessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelProcessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelProcessResponse>(create);
  static CancelProcessResponse? _defaultInstance;
}

class ListProcessesRequest extends $pb.GeneratedMessage {
  factory ListProcessesRequest({
    $core.String? cursor,
    $core.int? limit,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListProcessesRequest._();

  factory ListProcessesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProcessesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProcessesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cursor')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProcessesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProcessesRequest copyWith(void Function(ListProcessesRequest) updates) =>
      super.copyWith((message) => updates(message as ListProcessesRequest))
          as ListProcessesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProcessesRequest create() => ListProcessesRequest._();
  @$core.override
  ListProcessesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProcessesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProcessesRequest>(create);
  static ListProcessesRequest? _defaultInstance;

  /// Opaque cursor for pagination. Empty string for the first page.
  @$pb.TagNumber(1)
  $core.String get cursor => $_getSZ(0);
  @$pb.TagNumber(1)
  set cursor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  /// Maximum number of processes to return. Defaults to 20 if not set.
  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class ListProcessesResponse extends $pb.GeneratedMessage {
  factory ListProcessesResponse({
    $core.Iterable<Process>? processes,
    $core.String? nextCursor,
  }) {
    final result = create();
    if (processes != null) result.processes.addAll(processes);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListProcessesResponse._();

  factory ListProcessesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProcessesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProcessesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..pPM<Process>(1, _omitFieldNames ? '' : 'processes',
        subBuilder: Process.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProcessesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProcessesResponse copyWith(
          void Function(ListProcessesResponse) updates) =>
      super.copyWith((message) => updates(message as ListProcessesResponse))
          as ListProcessesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProcessesResponse create() => ListProcessesResponse._();
  @$core.override
  ListProcessesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProcessesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProcessesResponse>(create);
  static ListProcessesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Process> get processes => $_getList(0);

  /// Cursor for the next page. Empty if no more results.
  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class GetProcessRequest extends $pb.GeneratedMessage {
  factory GetProcessRequest({
    $core.String? processId,
  }) {
    final result = create();
    if (processId != null) result.processId = processId;
    return result;
  }

  GetProcessRequest._();

  factory GetProcessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProcessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProcessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'processId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessRequest copyWith(void Function(GetProcessRequest) updates) =>
      super.copyWith((message) => updates(message as GetProcessRequest))
          as GetProcessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProcessRequest create() => GetProcessRequest._();
  @$core.override
  GetProcessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProcessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProcessRequest>(create);
  static GetProcessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processId => $_getSZ(0);
  @$pb.TagNumber(1)
  set processId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessId() => $_clearField(1);
}

class GetProcessResponse extends $pb.GeneratedMessage {
  factory GetProcessResponse({
    Process? process,
    $core.Iterable<Upload>? uploads,
  }) {
    final result = create();
    if (process != null) result.process = process;
    if (uploads != null) result.uploads.addAll(uploads);
    return result;
  }

  GetProcessResponse._();

  factory GetProcessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProcessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProcessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOM<Process>(1, _omitFieldNames ? '' : 'process',
        subBuilder: Process.create)
    ..pPM<Upload>(2, _omitFieldNames ? '' : 'uploads',
        subBuilder: Upload.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessResponse copyWith(void Function(GetProcessResponse) updates) =>
      super.copyWith((message) => updates(message as GetProcessResponse))
          as GetProcessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProcessResponse create() => GetProcessResponse._();
  @$core.override
  GetProcessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProcessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProcessResponse>(create);
  static GetProcessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Process get process => $_getN(0);
  @$pb.TagNumber(1)
  set process(Process value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProcess() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcess() => $_clearField(1);
  @$pb.TagNumber(1)
  Process ensureProcess() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Upload> get uploads => $_getList(1);
}

/// UploadProgress contains real-time progress data for an upload operation.
class UploadProgress extends $pb.GeneratedMessage {
  factory UploadProgress({
    $core.String? processId,
    $core.String? uploadId,
    $core.String? filePath,
    $fixnum.Int64? fileSize,
    $fixnum.Int64? bytesUploaded,
    Status? status,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (processId != null) result.processId = processId;
    if (uploadId != null) result.uploadId = uploadId;
    if (filePath != null) result.filePath = filePath;
    if (fileSize != null) result.fileSize = fileSize;
    if (bytesUploaded != null) result.bytesUploaded = bytesUploaded;
    if (status != null) result.status = status;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  UploadProgress._();

  factory UploadProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadProgress',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'processId')
    ..aOS(2, _omitFieldNames ? '' : 'uploadId')
    ..aOS(3, _omitFieldNames ? '' : 'filePath')
    ..aInt64(4, _omitFieldNames ? '' : 'fileSize')
    ..aInt64(5, _omitFieldNames ? '' : 'bytesUploaded')
    ..aE<Status>(6, _omitFieldNames ? '' : 'status', enumValues: Status.values)
    ..aOS(7, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadProgress copyWith(void Function(UploadProgress) updates) =>
      super.copyWith((message) => updates(message as UploadProgress))
          as UploadProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadProgress create() => UploadProgress._();
  @$core.override
  UploadProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadProgress>(create);
  static UploadProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processId => $_getSZ(0);
  @$pb.TagNumber(1)
  set processId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uploadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set uploadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUploadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUploadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filePath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilePath() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fileSize => $_getI64(3);
  @$pb.TagNumber(4)
  set fileSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFileSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get bytesUploaded => $_getI64(4);
  @$pb.TagNumber(5)
  set bytesUploaded($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBytesUploaded() => $_has(4);
  @$pb.TagNumber(5)
  void clearBytesUploaded() => $_clearField(5);

  @$pb.TagNumber(6)
  Status get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(Status value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorMessage($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorMessage() => $_clearField(7);
}

/// Process represents a logical grouping of one or more file uploads.
class Process extends $pb.GeneratedMessage {
  factory Process({
    $core.String? id,
    ProcessType? type,
    Status? status,
    $core.String? provider,
    $core.String? sourcePath,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (provider != null) result.provider = provider;
    if (sourcePath != null) result.sourcePath = sourcePath;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Process._();

  factory Process.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Process.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Process',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<ProcessType>(2, _omitFieldNames ? '' : 'type',
        enumValues: ProcessType.values)
    ..aE<Status>(3, _omitFieldNames ? '' : 'status', enumValues: Status.values)
    ..aOS(4, _omitFieldNames ? '' : 'provider')
    ..aOS(5, _omitFieldNames ? '' : 'sourcePath')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Process clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Process copyWith(void Function(Process) updates) =>
      super.copyWith((message) => updates(message as Process)) as Process;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Process create() => Process._();
  @$core.override
  Process createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Process getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Process>(create);
  static Process? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ProcessType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ProcessType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  Status get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(Status value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourcePath => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourcePath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourcePath() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourcePath() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureUpdatedAt() => $_ensure(6);
}

/// Upload represents a single file upload within a process.
class Upload extends $pb.GeneratedMessage {
  factory Upload({
    $core.String? id,
    $core.String? processId,
    $core.String? filePath,
    $core.String? storageKey,
    $fixnum.Int64? fileSize,
    $fixnum.Int64? bytesUploaded,
    Status? status,
    $core.String? errorMessage,
    $core.String? checksum,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (processId != null) result.processId = processId;
    if (filePath != null) result.filePath = filePath;
    if (storageKey != null) result.storageKey = storageKey;
    if (fileSize != null) result.fileSize = fileSize;
    if (bytesUploaded != null) result.bytesUploaded = bytesUploaded;
    if (status != null) result.status = status;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (checksum != null) result.checksum = checksum;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Upload._();

  factory Upload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Upload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'processId')
    ..aOS(3, _omitFieldNames ? '' : 'filePath')
    ..aOS(4, _omitFieldNames ? '' : 'storageKey')
    ..aInt64(5, _omitFieldNames ? '' : 'fileSize')
    ..aInt64(6, _omitFieldNames ? '' : 'bytesUploaded')
    ..aE<Status>(7, _omitFieldNames ? '' : 'status', enumValues: Status.values)
    ..aOS(8, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(9, _omitFieldNames ? '' : 'checksum')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload copyWith(void Function(Upload) updates) =>
      super.copyWith((message) => updates(message as Upload)) as Upload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload create() => Upload._();
  @$core.override
  Upload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload>(create);
  static Upload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get processId => $_getSZ(1);
  @$pb.TagNumber(2)
  set processId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProcessId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProcessId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filePath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilePath() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get storageKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set storageKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStorageKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearStorageKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get fileSize => $_getI64(4);
  @$pb.TagNumber(5)
  set fileSize($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get bytesUploaded => $_getI64(5);
  @$pb.TagNumber(6)
  set bytesUploaded($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBytesUploaded() => $_has(5);
  @$pb.TagNumber(6)
  void clearBytesUploaded() => $_clearField(6);

  @$pb.TagNumber(7)
  Status get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(Status value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get errorMessage => $_getSZ(7);
  @$pb.TagNumber(8)
  set errorMessage($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasErrorMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearErrorMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get checksum => $_getSZ(8);
  @$pb.TagNumber(9)
  set checksum($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasChecksum() => $_has(8);
  @$pb.TagNumber(9)
  void clearChecksum() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
