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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'config_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'config_service.pbenum.dart';

class GetConfigRequest extends $pb.GeneratedMessage {
  factory GetConfigRequest() => create();

  GetConfigRequest._();

  factory GetConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConfigRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConfigRequest copyWith(void Function(GetConfigRequest) updates) =>
      super.copyWith((message) => updates(message as GetConfigRequest))
          as GetConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConfigRequest create() => GetConfigRequest._();
  @$core.override
  GetConfigRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConfigRequest>(create);
  static GetConfigRequest? _defaultInstance;
}

class GetConfigResponse extends $pb.GeneratedMessage {
  factory GetConfigResponse({
    $core.String? activeProvider,
    $fixnum.Int64? uploadPartSize,
    $core.int? uploadMaxConcurrent,
    $core.int? grpcPort,
  }) {
    final result = create();
    if (activeProvider != null) result.activeProvider = activeProvider;
    if (uploadPartSize != null) result.uploadPartSize = uploadPartSize;
    if (uploadMaxConcurrent != null)
      result.uploadMaxConcurrent = uploadMaxConcurrent;
    if (grpcPort != null) result.grpcPort = grpcPort;
    return result;
  }

  GetConfigResponse._();

  factory GetConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConfigResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'activeProvider')
    ..aInt64(2, _omitFieldNames ? '' : 'uploadPartSize')
    ..aI(3, _omitFieldNames ? '' : 'uploadMaxConcurrent')
    ..aI(4, _omitFieldNames ? '' : 'grpcPort')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConfigResponse copyWith(void Function(GetConfigResponse) updates) =>
      super.copyWith((message) => updates(message as GetConfigResponse))
          as GetConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConfigResponse create() => GetConfigResponse._();
  @$core.override
  GetConfigResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConfigResponse>(create);
  static GetConfigResponse? _defaultInstance;

  /// Active storage provider name (e.g., "S3").
  @$pb.TagNumber(1)
  $core.String get activeProvider => $_getSZ(0);
  @$pb.TagNumber(1)
  set activeProvider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveProvider() => $_clearField(1);

  /// Upload part size in bytes.
  @$pb.TagNumber(2)
  $fixnum.Int64 get uploadPartSize => $_getI64(1);
  @$pb.TagNumber(2)
  set uploadPartSize($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUploadPartSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearUploadPartSize() => $_clearField(2);

  /// Maximum number of concurrent uploads.
  @$pb.TagNumber(3)
  $core.int get uploadMaxConcurrent => $_getIZ(2);
  @$pb.TagNumber(3)
  set uploadMaxConcurrent($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUploadMaxConcurrent() => $_has(2);
  @$pb.TagNumber(3)
  void clearUploadMaxConcurrent() => $_clearField(3);

  /// gRPC server port.
  @$pb.TagNumber(4)
  $core.int get grpcPort => $_getIZ(3);
  @$pb.TagNumber(4)
  set grpcPort($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGrpcPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearGrpcPort() => $_clearField(4);
}

class ListProvidersRequest extends $pb.GeneratedMessage {
  factory ListProvidersRequest() => create();

  ListProvidersRequest._();

  factory ListProvidersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProvidersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProvidersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvidersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvidersRequest copyWith(void Function(ListProvidersRequest) updates) =>
      super.copyWith((message) => updates(message as ListProvidersRequest))
          as ListProvidersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProvidersRequest create() => ListProvidersRequest._();
  @$core.override
  ListProvidersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProvidersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProvidersRequest>(create);
  static ListProvidersRequest? _defaultInstance;
}

class ListProvidersResponse extends $pb.GeneratedMessage {
  factory ListProvidersResponse({
    $core.Iterable<Provider>? providers,
  }) {
    final result = create();
    if (providers != null) result.providers.addAll(providers);
    return result;
  }

  ListProvidersResponse._();

  factory ListProvidersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProvidersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProvidersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..pPM<Provider>(1, _omitFieldNames ? '' : 'providers',
        subBuilder: Provider.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvidersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvidersResponse copyWith(
          void Function(ListProvidersResponse) updates) =>
      super.copyWith((message) => updates(message as ListProvidersResponse))
          as ListProvidersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProvidersResponse create() => ListProvidersResponse._();
  @$core.override
  ListProvidersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProvidersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProvidersResponse>(create);
  static ListProvidersResponse? _defaultInstance;

  /// All registered storage providers with their configuration schemas.
  @$pb.TagNumber(1)
  $pb.PbList<Provider> get providers => $_getList(0);
}

/// Provider describes a storage provider and its configuration schema.
class Provider extends $pb.GeneratedMessage {
  factory Provider({
    $core.String? name,
    $core.String? displayName,
    $core.bool? active,
    $core.Iterable<ProviderField>? fields,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (displayName != null) result.displayName = displayName;
    if (active != null) result.active = active;
    if (fields != null) result.fields.addAll(fields);
    return result;
  }

  Provider._();

  factory Provider.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Provider.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Provider',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOB(3, _omitFieldNames ? '' : 'active')
    ..pPM<ProviderField>(4, _omitFieldNames ? '' : 'fields',
        subBuilder: ProviderField.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provider clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provider copyWith(void Function(Provider) updates) =>
      super.copyWith((message) => updates(message as Provider)) as Provider;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Provider create() => Provider._();
  @$core.override
  Provider createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Provider getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Provider>(create);
  static Provider? _defaultInstance;

  /// Unique provider identifier (e.g., "S3", "AZURE", "MEGA").
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Human-readable display name (e.g., "Amazon S3", "Azure Blob Storage").
  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  /// Whether this provider is currently active.
  @$pb.TagNumber(3)
  $core.bool get active => $_getBF(2);
  @$pb.TagNumber(3)
  set active($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearActive() => $_clearField(3);

  /// Configuration fields required by this provider.
  @$pb.TagNumber(4)
  $pb.PbList<ProviderField> get fields => $_getList(3);
}

class UpdateProviderConfigRequest extends $pb.GeneratedMessage {
  factory UpdateProviderConfigRequest({
    $core.String? provider,
    $core.Iterable<ProviderFieldValue>? fields,
    $core.bool? setActive,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (fields != null) result.fields.addAll(fields);
    if (setActive != null) result.setActive = setActive;
    return result;
  }

  UpdateProviderConfigRequest._();

  factory UpdateProviderConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProviderConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProviderConfigRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..pPM<ProviderFieldValue>(2, _omitFieldNames ? '' : 'fields',
        subBuilder: ProviderFieldValue.create)
    ..aOB(3, _omitFieldNames ? '' : 'setActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderConfigRequest copyWith(
          void Function(UpdateProviderConfigRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateProviderConfigRequest))
          as UpdateProviderConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProviderConfigRequest create() =>
      UpdateProviderConfigRequest._();
  @$core.override
  UpdateProviderConfigRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProviderConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProviderConfigRequest>(create);
  static UpdateProviderConfigRequest? _defaultInstance;

  /// Provider identifier (e.g., "S3").
  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Field values to save. Secret fields go to OS keychain, others to database.
  @$pb.TagNumber(2)
  $pb.PbList<ProviderFieldValue> get fields => $_getList(1);

  /// Whether to set this provider as the active provider.
  @$pb.TagNumber(3)
  $core.bool get setActive => $_getBF(2);
  @$pb.TagNumber(3)
  set setActive($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetActive() => $_clearField(3);
}

class UpdateProviderConfigResponse extends $pb.GeneratedMessage {
  factory UpdateProviderConfigResponse() => create();

  UpdateProviderConfigResponse._();

  factory UpdateProviderConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProviderConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProviderConfigResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderConfigResponse copyWith(
          void Function(UpdateProviderConfigResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateProviderConfigResponse))
          as UpdateProviderConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProviderConfigResponse create() =>
      UpdateProviderConfigResponse._();
  @$core.override
  UpdateProviderConfigResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProviderConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProviderConfigResponse>(create);
  static UpdateProviderConfigResponse? _defaultInstance;
}

/// ProviderFieldValue is a key-value pair sent by the client when saving config.
class ProviderFieldValue extends $pb.GeneratedMessage {
  factory ProviderFieldValue({
    $core.String? key,
    $core.String? value,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    return result;
  }

  ProviderFieldValue._();

  factory ProviderFieldValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderFieldValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderFieldValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderFieldValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderFieldValue copyWith(void Function(ProviderFieldValue) updates) =>
      super.copyWith((message) => updates(message as ProviderFieldValue))
          as ProviderFieldValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderFieldValue create() => ProviderFieldValue._();
  @$core.override
  ProviderFieldValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderFieldValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderFieldValue>(create);
  static ProviderFieldValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

/// ProviderField describes a single configuration field for a storage provider.
class ProviderField extends $pb.GeneratedMessage {
  factory ProviderField({
    $core.String? key,
    $core.String? label,
    FieldType? type,
    $core.bool? required,
    $core.String? value,
    $core.String? placeholder,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (type != null) result.type = type;
    if (required != null) result.required = required;
    if (value != null) result.value = value;
    if (placeholder != null) result.placeholder = placeholder;
    return result;
  }

  ProviderField._();

  factory ProviderField.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderField.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderField',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'fileguardian.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aE<FieldType>(3, _omitFieldNames ? '' : 'type',
        enumValues: FieldType.values)
    ..aOB(4, _omitFieldNames ? '' : 'required')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'placeholder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderField clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderField copyWith(void Function(ProviderField) updates) =>
      super.copyWith((message) => updates(message as ProviderField))
          as ProviderField;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderField create() => ProviderField._();
  @$core.override
  ProviderField createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderField getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderField>(create);
  static ProviderField? _defaultInstance;

  /// Field identifier used as the environment variable suffix
  /// (e.g., "region" maps to AWS_REGION).
  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  /// Human-readable label for the field (e.g., "Region").
  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  /// Field data type.
  @$pb.TagNumber(3)
  FieldType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(FieldType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  /// Whether this field is required.
  @$pb.TagNumber(4)
  $core.bool get required => $_getBF(3);
  @$pb.TagNumber(4)
  set required($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequired() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequired() => $_clearField(4);

  /// Current configured value. Empty for SECRET fields.
  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  /// Placeholder or example value (e.g., "us-east-1").
  @$pb.TagNumber(6)
  $core.String get placeholder => $_getSZ(5);
  @$pb.TagNumber(6)
  set placeholder($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlaceholder() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlaceholder() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
