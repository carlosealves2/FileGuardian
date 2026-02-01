// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/upload_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'upload_service.pb.dart' as $0;

export 'upload_service.pb.dart';

/// UploadService manages file and folder uploads with pause, resume, and cancel
/// capabilities. All upload operations return a server-side stream of progress
/// updates.
@$pb.GrpcServiceName('fileguardian.v1.UploadService')
class UploadServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UploadServiceClient(super.channel, {super.options, super.interceptors});

  /// UploadFile initiates a single file upload and streams progress updates.
  $grpc.ResponseStream<$0.UploadFileResponse> uploadFile(
    $0.UploadFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$uploadFile, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// UploadFolder initiates a folder upload and streams progress updates for
  /// each file within the folder.
  $grpc.ResponseStream<$0.UploadFolderResponse> uploadFolder(
    $0.UploadFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$uploadFolder, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// PauseProcess pauses all active uploads within a process. The current part
  /// in progress will complete before pausing.
  $grpc.ResponseFuture<$0.PauseProcessResponse> pauseProcess(
    $0.PauseProcessRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseProcess, request, options: options);
  }

  /// ResumeProcess resumes a paused process and streams progress updates.
  $grpc.ResponseStream<$0.ResumeProcessResponse> resumeProcess(
    $0.ResumeProcessRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$resumeProcess, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// CancelProcess cancels a process and aborts all associated multipart uploads
  /// on the storage provider.
  $grpc.ResponseFuture<$0.CancelProcessResponse> cancelProcess(
    $0.CancelProcessRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelProcess, request, options: options);
  }

  /// ListProcesses returns a paginated list of processes using cursor-based
  /// pagination.
  $grpc.ResponseFuture<$0.ListProcessesResponse> listProcesses(
    $0.ListProcessesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listProcesses, request, options: options);
  }

  /// GetProcess returns a process with all its associated uploads.
  $grpc.ResponseFuture<$0.GetProcessResponse> getProcess(
    $0.GetProcessRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProcess, request, options: options);
  }

  // method descriptors

  static final _$uploadFile =
      $grpc.ClientMethod<$0.UploadFileRequest, $0.UploadFileResponse>(
          '/fileguardian.v1.UploadService/UploadFile',
          ($0.UploadFileRequest value) => value.writeToBuffer(),
          $0.UploadFileResponse.fromBuffer);
  static final _$uploadFolder =
      $grpc.ClientMethod<$0.UploadFolderRequest, $0.UploadFolderResponse>(
          '/fileguardian.v1.UploadService/UploadFolder',
          ($0.UploadFolderRequest value) => value.writeToBuffer(),
          $0.UploadFolderResponse.fromBuffer);
  static final _$pauseProcess =
      $grpc.ClientMethod<$0.PauseProcessRequest, $0.PauseProcessResponse>(
          '/fileguardian.v1.UploadService/PauseProcess',
          ($0.PauseProcessRequest value) => value.writeToBuffer(),
          $0.PauseProcessResponse.fromBuffer);
  static final _$resumeProcess =
      $grpc.ClientMethod<$0.ResumeProcessRequest, $0.ResumeProcessResponse>(
          '/fileguardian.v1.UploadService/ResumeProcess',
          ($0.ResumeProcessRequest value) => value.writeToBuffer(),
          $0.ResumeProcessResponse.fromBuffer);
  static final _$cancelProcess =
      $grpc.ClientMethod<$0.CancelProcessRequest, $0.CancelProcessResponse>(
          '/fileguardian.v1.UploadService/CancelProcess',
          ($0.CancelProcessRequest value) => value.writeToBuffer(),
          $0.CancelProcessResponse.fromBuffer);
  static final _$listProcesses =
      $grpc.ClientMethod<$0.ListProcessesRequest, $0.ListProcessesResponse>(
          '/fileguardian.v1.UploadService/ListProcesses',
          ($0.ListProcessesRequest value) => value.writeToBuffer(),
          $0.ListProcessesResponse.fromBuffer);
  static final _$getProcess =
      $grpc.ClientMethod<$0.GetProcessRequest, $0.GetProcessResponse>(
          '/fileguardian.v1.UploadService/GetProcess',
          ($0.GetProcessRequest value) => value.writeToBuffer(),
          $0.GetProcessResponse.fromBuffer);
}

@$pb.GrpcServiceName('fileguardian.v1.UploadService')
abstract class UploadServiceBase extends $grpc.Service {
  $core.String get $name => 'fileguardian.v1.UploadService';

  UploadServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.UploadFileRequest, $0.UploadFileResponse>(
        'UploadFile',
        uploadFile_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.UploadFileRequest.fromBuffer(value),
        ($0.UploadFileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UploadFolderRequest, $0.UploadFolderResponse>(
            'UploadFolder',
            uploadFolder_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.UploadFolderRequest.fromBuffer(value),
            ($0.UploadFolderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PauseProcessRequest, $0.PauseProcessResponse>(
            'PauseProcess',
            pauseProcess_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PauseProcessRequest.fromBuffer(value),
            ($0.PauseProcessResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ResumeProcessRequest, $0.ResumeProcessResponse>(
            'ResumeProcess',
            resumeProcess_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.ResumeProcessRequest.fromBuffer(value),
            ($0.ResumeProcessResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CancelProcessRequest, $0.CancelProcessResponse>(
            'CancelProcess',
            cancelProcess_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CancelProcessRequest.fromBuffer(value),
            ($0.CancelProcessResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListProcessesRequest, $0.ListProcessesResponse>(
            'ListProcesses',
            listProcesses_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListProcessesRequest.fromBuffer(value),
            ($0.ListProcessesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetProcessRequest, $0.GetProcessResponse>(
        'GetProcess',
        getProcess_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetProcessRequest.fromBuffer(value),
        ($0.GetProcessResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.UploadFileResponse> uploadFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UploadFileRequest> $request) async* {
    yield* uploadFile($call, await $request);
  }

  $async.Stream<$0.UploadFileResponse> uploadFile(
      $grpc.ServiceCall call, $0.UploadFileRequest request);

  $async.Stream<$0.UploadFolderResponse> uploadFolder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UploadFolderRequest> $request) async* {
    yield* uploadFolder($call, await $request);
  }

  $async.Stream<$0.UploadFolderResponse> uploadFolder(
      $grpc.ServiceCall call, $0.UploadFolderRequest request);

  $async.Future<$0.PauseProcessResponse> pauseProcess_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PauseProcessRequest> $request) async {
    return pauseProcess($call, await $request);
  }

  $async.Future<$0.PauseProcessResponse> pauseProcess(
      $grpc.ServiceCall call, $0.PauseProcessRequest request);

  $async.Stream<$0.ResumeProcessResponse> resumeProcess_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResumeProcessRequest> $request) async* {
    yield* resumeProcess($call, await $request);
  }

  $async.Stream<$0.ResumeProcessResponse> resumeProcess(
      $grpc.ServiceCall call, $0.ResumeProcessRequest request);

  $async.Future<$0.CancelProcessResponse> cancelProcess_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelProcessRequest> $request) async {
    return cancelProcess($call, await $request);
  }

  $async.Future<$0.CancelProcessResponse> cancelProcess(
      $grpc.ServiceCall call, $0.CancelProcessRequest request);

  $async.Future<$0.ListProcessesResponse> listProcesses_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListProcessesRequest> $request) async {
    return listProcesses($call, await $request);
  }

  $async.Future<$0.ListProcessesResponse> listProcesses(
      $grpc.ServiceCall call, $0.ListProcessesRequest request);

  $async.Future<$0.GetProcessResponse> getProcess_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProcessRequest> $request) async {
    return getProcess($call, await $request);
  }

  $async.Future<$0.GetProcessResponse> getProcess(
      $grpc.ServiceCall call, $0.GetProcessRequest request);
}
