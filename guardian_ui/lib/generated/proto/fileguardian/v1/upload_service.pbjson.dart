// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/upload_service.proto.

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

@$core.Deprecated('Use processTypeDescriptor instead')
const ProcessType$json = {
  '1': 'ProcessType',
  '2': [
    {'1': 'PROCESS_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PROCESS_TYPE_FILE', '2': 1},
    {'1': 'PROCESS_TYPE_FOLDER', '2': 2},
  ],
};

/// Descriptor for `ProcessType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List processTypeDescriptor = $convert.base64Decode(
    'CgtQcm9jZXNzVHlwZRIcChhQUk9DRVNTX1RZUEVfVU5TUEVDSUZJRUQQABIVChFQUk9DRVNTX1'
    'RZUEVfRklMRRABEhcKE1BST0NFU1NfVFlQRV9GT0xERVIQAg==');

@$core.Deprecated('Use statusDescriptor instead')
const Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'STATUS_UNSPECIFIED', '2': 0},
    {'1': 'STATUS_PENDING', '2': 1},
    {'1': 'STATUS_IN_PROGRESS', '2': 2},
    {'1': 'STATUS_PAUSED', '2': 3},
    {'1': 'STATUS_COMPLETED', '2': 4},
    {'1': 'STATUS_FAILED', '2': 5},
    {'1': 'STATUS_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `Status`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List statusDescriptor = $convert.base64Decode(
    'CgZTdGF0dXMSFgoSU1RBVFVTX1VOU1BFQ0lGSUVEEAASEgoOU1RBVFVTX1BFTkRJTkcQARIWCh'
    'JTVEFUVVNfSU5fUFJPR1JFU1MQAhIRCg1TVEFUVVNfUEFVU0VEEAMSFAoQU1RBVFVTX0NPTVBM'
    'RVRFRBAEEhEKDVNUQVRVU19GQUlMRUQQBRIUChBTVEFUVVNfQ0FOQ0VMTEVEEAY=');

@$core.Deprecated('Use uploadFileRequestDescriptor instead')
const UploadFileRequest$json = {
  '1': 'UploadFileRequest',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
  ],
};

/// Descriptor for `UploadFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFileRequestDescriptor = $convert.base64Decode(
    'ChFVcGxvYWRGaWxlUmVxdWVzdBIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRo');

@$core.Deprecated('Use uploadFileResponseDescriptor instead')
const UploadFileResponse$json = {
  '1': 'UploadFileResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fileguardian.v1.UploadProgress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `UploadFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFileResponseDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRGaWxlUmVzcG9uc2USOwoIcHJvZ3Jlc3MYASABKAsyHy5maWxlZ3VhcmRpYW4udj'
    'EuVXBsb2FkUHJvZ3Jlc3NSCHByb2dyZXNz');

@$core.Deprecated('Use uploadFolderRequestDescriptor instead')
const UploadFolderRequest$json = {
  '1': 'UploadFolderRequest',
  '2': [
    {'1': 'folder_path', '3': 1, '4': 1, '5': 9, '10': 'folderPath'},
  ],
};

/// Descriptor for `UploadFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFolderRequestDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRGb2xkZXJSZXF1ZXN0Eh8KC2ZvbGRlcl9wYXRoGAEgASgJUgpmb2xkZXJQYXRo');

@$core.Deprecated('Use uploadFolderResponseDescriptor instead')
const UploadFolderResponse$json = {
  '1': 'UploadFolderResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fileguardian.v1.UploadProgress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `UploadFolderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFolderResponseDescriptor = $convert.base64Decode(
    'ChRVcGxvYWRGb2xkZXJSZXNwb25zZRI7Cghwcm9ncmVzcxgBIAEoCzIfLmZpbGVndWFyZGlhbi'
    '52MS5VcGxvYWRQcm9ncmVzc1IIcHJvZ3Jlc3M=');

@$core.Deprecated('Use pauseProcessRequestDescriptor instead')
const PauseProcessRequest$json = {
  '1': 'PauseProcessRequest',
  '2': [
    {'1': 'process_id', '3': 1, '4': 1, '5': 9, '10': 'processId'},
  ],
};

/// Descriptor for `PauseProcessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseProcessRequestDescriptor = $convert.base64Decode(
    'ChNQYXVzZVByb2Nlc3NSZXF1ZXN0Eh0KCnByb2Nlc3NfaWQYASABKAlSCXByb2Nlc3NJZA==');

@$core.Deprecated('Use pauseProcessResponseDescriptor instead')
const PauseProcessResponse$json = {
  '1': 'PauseProcessResponse',
};

/// Descriptor for `PauseProcessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseProcessResponseDescriptor =
    $convert.base64Decode('ChRQYXVzZVByb2Nlc3NSZXNwb25zZQ==');

@$core.Deprecated('Use resumeProcessRequestDescriptor instead')
const ResumeProcessRequest$json = {
  '1': 'ResumeProcessRequest',
  '2': [
    {'1': 'process_id', '3': 1, '4': 1, '5': 9, '10': 'processId'},
  ],
};

/// Descriptor for `ResumeProcessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeProcessRequestDescriptor = $convert.base64Decode(
    'ChRSZXN1bWVQcm9jZXNzUmVxdWVzdBIdCgpwcm9jZXNzX2lkGAEgASgJUglwcm9jZXNzSWQ=');

@$core.Deprecated('Use resumeProcessResponseDescriptor instead')
const ResumeProcessResponse$json = {
  '1': 'ResumeProcessResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fileguardian.v1.UploadProgress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `ResumeProcessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeProcessResponseDescriptor = $convert.base64Decode(
    'ChVSZXN1bWVQcm9jZXNzUmVzcG9uc2USOwoIcHJvZ3Jlc3MYASABKAsyHy5maWxlZ3VhcmRpYW'
    '4udjEuVXBsb2FkUHJvZ3Jlc3NSCHByb2dyZXNz');

@$core.Deprecated('Use cancelProcessRequestDescriptor instead')
const CancelProcessRequest$json = {
  '1': 'CancelProcessRequest',
  '2': [
    {'1': 'process_id', '3': 1, '4': 1, '5': 9, '10': 'processId'},
  ],
};

/// Descriptor for `CancelProcessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelProcessRequestDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxQcm9jZXNzUmVxdWVzdBIdCgpwcm9jZXNzX2lkGAEgASgJUglwcm9jZXNzSWQ=');

@$core.Deprecated('Use cancelProcessResponseDescriptor instead')
const CancelProcessResponse$json = {
  '1': 'CancelProcessResponse',
};

/// Descriptor for `CancelProcessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelProcessResponseDescriptor =
    $convert.base64Decode('ChVDYW5jZWxQcm9jZXNzUmVzcG9uc2U=');

@$core.Deprecated('Use listProcessesRequestDescriptor instead')
const ListProcessesRequest$json = {
  '1': 'ListProcessesRequest',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 9, '10': 'cursor'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListProcessesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProcessesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvY2Vzc2VzUmVxdWVzdBIWCgZjdXJzb3IYASABKAlSBmN1cnNvchIUCgVsaW1pdB'
    'gCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use listProcessesResponseDescriptor instead')
const ListProcessesResponse$json = {
  '1': 'ListProcessesResponse',
  '2': [
    {
      '1': 'processes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.fileguardian.v1.Process',
      '10': 'processes'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListProcessesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProcessesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UHJvY2Vzc2VzUmVzcG9uc2USNgoJcHJvY2Vzc2VzGAEgAygLMhguZmlsZWd1YXJkaW'
    'FuLnYxLlByb2Nlc3NSCXByb2Nlc3NlcxIfCgtuZXh0X2N1cnNvchgCIAEoCVIKbmV4dEN1cnNv'
    'cg==');

@$core.Deprecated('Use getProcessRequestDescriptor instead')
const GetProcessRequest$json = {
  '1': 'GetProcessRequest',
  '2': [
    {'1': 'process_id', '3': 1, '4': 1, '5': 9, '10': 'processId'},
  ],
};

/// Descriptor for `GetProcessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProcessRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9jZXNzUmVxdWVzdBIdCgpwcm9jZXNzX2lkGAEgASgJUglwcm9jZXNzSWQ=');

@$core.Deprecated('Use getProcessResponseDescriptor instead')
const GetProcessResponse$json = {
  '1': 'GetProcessResponse',
  '2': [
    {
      '1': 'process',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fileguardian.v1.Process',
      '10': 'process'
    },
    {
      '1': 'uploads',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.fileguardian.v1.Upload',
      '10': 'uploads'
    },
  ],
};

/// Descriptor for `GetProcessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProcessResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9jZXNzUmVzcG9uc2USMgoHcHJvY2VzcxgBIAEoCzIYLmZpbGVndWFyZGlhbi52MS'
    '5Qcm9jZXNzUgdwcm9jZXNzEjEKB3VwbG9hZHMYAiADKAsyFy5maWxlZ3VhcmRpYW4udjEuVXBs'
    'b2FkUgd1cGxvYWRz');

@$core.Deprecated('Use uploadProgressDescriptor instead')
const UploadProgress$json = {
  '1': 'UploadProgress',
  '2': [
    {'1': 'process_id', '3': 1, '4': 1, '5': 9, '10': 'processId'},
    {'1': 'upload_id', '3': 2, '4': 1, '5': 9, '10': 'uploadId'},
    {'1': 'file_path', '3': 3, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'file_size', '3': 4, '4': 1, '5': 3, '10': 'fileSize'},
    {'1': 'bytes_uploaded', '3': 5, '4': 1, '5': 3, '10': 'bytesUploaded'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.fileguardian.v1.Status',
      '10': 'status'
    },
    {'1': 'error_message', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `UploadProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadProgressDescriptor = $convert.base64Decode(
    'Cg5VcGxvYWRQcm9ncmVzcxIdCgpwcm9jZXNzX2lkGAEgASgJUglwcm9jZXNzSWQSGwoJdXBsb2'
    'FkX2lkGAIgASgJUgh1cGxvYWRJZBIbCglmaWxlX3BhdGgYAyABKAlSCGZpbGVQYXRoEhsKCWZp'
    'bGVfc2l6ZRgEIAEoA1IIZmlsZVNpemUSJQoOYnl0ZXNfdXBsb2FkZWQYBSABKANSDWJ5dGVzVX'
    'Bsb2FkZWQSLwoGc3RhdHVzGAYgASgOMhcuZmlsZWd1YXJkaWFuLnYxLlN0YXR1c1IGc3RhdHVz'
    'EiMKDWVycm9yX21lc3NhZ2UYByABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use processDescriptor instead')
const Process$json = {
  '1': 'Process',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.fileguardian.v1.ProcessType',
      '10': 'type'
    },
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.fileguardian.v1.Status',
      '10': 'status'
    },
    {'1': 'provider', '3': 4, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'source_path', '3': 5, '4': 1, '5': 9, '10': 'sourcePath'},
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Process`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processDescriptor = $convert.base64Decode(
    'CgdQcm9jZXNzEg4KAmlkGAEgASgJUgJpZBIwCgR0eXBlGAIgASgOMhwuZmlsZWd1YXJkaWFuLn'
    'YxLlByb2Nlc3NUeXBlUgR0eXBlEi8KBnN0YXR1cxgDIAEoDjIXLmZpbGVndWFyZGlhbi52MS5T'
    'dGF0dXNSBnN0YXR1cxIaCghwcm92aWRlchgEIAEoCVIIcHJvdmlkZXISHwoLc291cmNlX3BhdG'
    'gYBSABKAlSCnNvdXJjZVBhdGgSOQoKY3JlYXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use uploadDescriptor instead')
const Upload$json = {
  '1': 'Upload',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'process_id', '3': 2, '4': 1, '5': 9, '10': 'processId'},
    {'1': 'file_path', '3': 3, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'storage_key', '3': 4, '4': 1, '5': 9, '10': 'storageKey'},
    {'1': 'file_size', '3': 5, '4': 1, '5': 3, '10': 'fileSize'},
    {'1': 'bytes_uploaded', '3': 6, '4': 1, '5': 3, '10': 'bytesUploaded'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.fileguardian.v1.Status',
      '10': 'status'
    },
    {'1': 'error_message', '3': 8, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'checksum', '3': 9, '4': 1, '5': 9, '10': 'checksum'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Upload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadDescriptor = $convert.base64Decode(
    'CgZVcGxvYWQSDgoCaWQYASABKAlSAmlkEh0KCnByb2Nlc3NfaWQYAiABKAlSCXByb2Nlc3NJZB'
    'IbCglmaWxlX3BhdGgYAyABKAlSCGZpbGVQYXRoEh8KC3N0b3JhZ2Vfa2V5GAQgASgJUgpzdG9y'
    'YWdlS2V5EhsKCWZpbGVfc2l6ZRgFIAEoA1IIZmlsZVNpemUSJQoOYnl0ZXNfdXBsb2FkZWQYBi'
    'ABKANSDWJ5dGVzVXBsb2FkZWQSLwoGc3RhdHVzGAcgASgOMhcuZmlsZWd1YXJkaWFuLnYxLlN0'
    'YXR1c1IGc3RhdHVzEiMKDWVycm9yX21lc3NhZ2UYCCABKAlSDGVycm9yTWVzc2FnZRIaCghjaG'
    'Vja3N1bRgJIAEoCVIIY2hlY2tzdW0SOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAsgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
