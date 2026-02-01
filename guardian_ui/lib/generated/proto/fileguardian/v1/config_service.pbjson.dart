// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/config_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fieldTypeDescriptor instead')
const FieldType$json = {
  '1': 'FieldType',
  '2': [
    {'1': 'FIELD_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FIELD_TYPE_STRING', '2': 1},
    {'1': 'FIELD_TYPE_SECRET', '2': 2},
    {'1': 'FIELD_TYPE_NUMBER', '2': 3},
    {'1': 'FIELD_TYPE_BOOLEAN', '2': 4},
  ],
};

/// Descriptor for `FieldType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fieldTypeDescriptor = $convert.base64Decode(
    'CglGaWVsZFR5cGUSGgoWRklFTERfVFlQRV9VTlNQRUNJRklFRBAAEhUKEUZJRUxEX1RZUEVfU1'
    'RSSU5HEAESFQoRRklFTERfVFlQRV9TRUNSRVQQAhIVChFGSUVMRF9UWVBFX05VTUJFUhADEhYK'
    'EkZJRUxEX1RZUEVfQk9PTEVBThAE');

@$core.Deprecated('Use getConfigRequestDescriptor instead')
const GetConfigRequest$json = {
  '1': 'GetConfigRequest',
};

/// Descriptor for `GetConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigRequestDescriptor =
    $convert.base64Decode('ChBHZXRDb25maWdSZXF1ZXN0');

@$core.Deprecated('Use getConfigResponseDescriptor instead')
const GetConfigResponse$json = {
  '1': 'GetConfigResponse',
  '2': [
    {'1': 'active_provider', '3': 1, '4': 1, '5': 9, '10': 'activeProvider'},
    {'1': 'upload_part_size', '3': 2, '4': 1, '5': 3, '10': 'uploadPartSize'},
    {
      '1': 'upload_max_concurrent',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'uploadMaxConcurrent'
    },
    {'1': 'grpc_port', '3': 4, '4': 1, '5': 5, '10': 'grpcPort'},
  ],
};

/// Descriptor for `GetConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigResponseDescriptor = $convert.base64Decode(
    'ChFHZXRDb25maWdSZXNwb25zZRInCg9hY3RpdmVfcHJvdmlkZXIYASABKAlSDmFjdGl2ZVByb3'
    'ZpZGVyEigKEHVwbG9hZF9wYXJ0X3NpemUYAiABKANSDnVwbG9hZFBhcnRTaXplEjIKFXVwbG9h'
    'ZF9tYXhfY29uY3VycmVudBgDIAEoBVITdXBsb2FkTWF4Q29uY3VycmVudBIbCglncnBjX3Bvcn'
    'QYBCABKAVSCGdycGNQb3J0');

@$core.Deprecated('Use listProvidersRequestDescriptor instead')
const ListProvidersRequest$json = {
  '1': 'ListProvidersRequest',
};

/// Descriptor for `ListProvidersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProvidersRequestDescriptor =
    $convert.base64Decode('ChRMaXN0UHJvdmlkZXJzUmVxdWVzdA==');

@$core.Deprecated('Use listProvidersResponseDescriptor instead')
const ListProvidersResponse$json = {
  '1': 'ListProvidersResponse',
  '2': [
    {
      '1': 'providers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.fileguardian.v1.Provider',
      '10': 'providers'
    },
  ],
};

/// Descriptor for `ListProvidersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProvidersResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UHJvdmlkZXJzUmVzcG9uc2USNwoJcHJvdmlkZXJzGAEgAygLMhkuZmlsZWd1YXJkaW'
    'FuLnYxLlByb3ZpZGVyUglwcm92aWRlcnM=');

@$core.Deprecated('Use providerDescriptor instead')
const Provider$json = {
  '1': 'Provider',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'active', '3': 3, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'fields',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.fileguardian.v1.ProviderField',
      '10': 'fields'
    },
  ],
};

/// Descriptor for `Provider`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerDescriptor = $convert.base64Decode(
    'CghQcm92aWRlchISCgRuYW1lGAEgASgJUgRuYW1lEiEKDGRpc3BsYXlfbmFtZRgCIAEoCVILZG'
    'lzcGxheU5hbWUSFgoGYWN0aXZlGAMgASgIUgZhY3RpdmUSNgoGZmllbGRzGAQgAygLMh4uZmls'
    'ZWd1YXJkaWFuLnYxLlByb3ZpZGVyRmllbGRSBmZpZWxkcw==');

@$core.Deprecated('Use updateProviderConfigRequestDescriptor instead')
const UpdateProviderConfigRequest$json = {
  '1': 'UpdateProviderConfigRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '10': 'provider'},
    {
      '1': 'fields',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.fileguardian.v1.ProviderFieldValue',
      '10': 'fields'
    },
    {'1': 'set_active', '3': 3, '4': 1, '5': 8, '10': 'setActive'},
  ],
};

/// Descriptor for `UpdateProviderConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProviderConfigRequestDescriptor =
    $convert.base64Decode(
        'ChtVcGRhdGVQcm92aWRlckNvbmZpZ1JlcXVlc3QSGgoIcHJvdmlkZXIYASABKAlSCHByb3ZpZG'
        'VyEjsKBmZpZWxkcxgCIAMoCzIjLmZpbGVndWFyZGlhbi52MS5Qcm92aWRlckZpZWxkVmFsdWVS'
        'BmZpZWxkcxIdCgpzZXRfYWN0aXZlGAMgASgIUglzZXRBY3RpdmU=');

@$core.Deprecated('Use updateProviderConfigResponseDescriptor instead')
const UpdateProviderConfigResponse$json = {
  '1': 'UpdateProviderConfigResponse',
};

/// Descriptor for `UpdateProviderConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProviderConfigResponseDescriptor =
    $convert.base64Decode('ChxVcGRhdGVQcm92aWRlckNvbmZpZ1Jlc3BvbnNl');

@$core.Deprecated('Use providerFieldValueDescriptor instead')
const ProviderFieldValue$json = {
  '1': 'ProviderFieldValue',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `ProviderFieldValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerFieldValueDescriptor = $convert.base64Decode(
    'ChJQcm92aWRlckZpZWxkVmFsdWUSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBX'
    'ZhbHVl');

@$core.Deprecated('Use providerFieldDescriptor instead')
const ProviderField$json = {
  '1': 'ProviderField',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.fileguardian.v1.FieldType',
      '10': 'type'
    },
    {'1': 'required', '3': 4, '4': 1, '5': 8, '10': 'required'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
    {'1': 'placeholder', '3': 6, '4': 1, '5': 9, '10': 'placeholder'},
  ],
};

/// Descriptor for `ProviderField`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerFieldDescriptor = $convert.base64Decode(
    'Cg1Qcm92aWRlckZpZWxkEhAKA2tleRgBIAEoCVIDa2V5EhQKBWxhYmVsGAIgASgJUgVsYWJlbB'
    'IuCgR0eXBlGAMgASgOMhouZmlsZWd1YXJkaWFuLnYxLkZpZWxkVHlwZVIEdHlwZRIaCghyZXF1'
    'aXJlZBgEIAEoCFIIcmVxdWlyZWQSFAoFdmFsdWUYBSABKAlSBXZhbHVlEiAKC3BsYWNlaG9sZG'
    'VyGAYgASgJUgtwbGFjZWhvbGRlcg==');
