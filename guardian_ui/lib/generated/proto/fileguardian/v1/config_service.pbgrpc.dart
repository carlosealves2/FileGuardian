// This is a generated file - do not edit.
//
// Generated from fileguardian/v1/config_service.proto.

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

import 'config_service.pb.dart' as $0;

export 'config_service.pb.dart';

/// ConfigService manages application configuration and storage providers.
@$pb.GrpcServiceName('fileguardian.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConfigServiceClient(super.channel, {super.options, super.interceptors});

  /// GetConfig returns the current application configuration.
  $grpc.ResponseFuture<$0.GetConfigResponse> getConfig(
    $0.GetConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConfig, request, options: options);
  }

  /// ListProviders returns all available storage providers with their field
  /// schemas, allowing the frontend to dynamically build configuration forms.
  $grpc.ResponseFuture<$0.ListProvidersResponse> listProviders(
    $0.ListProvidersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listProviders, request, options: options);
  }

  /// UpdateProviderConfig saves configuration for a storage provider.
  /// Non-sensitive fields are persisted in the database.
  /// Secret fields are stored in the OS keychain.
  $grpc.ResponseFuture<$0.UpdateProviderConfigResponse> updateProviderConfig(
    $0.UpdateProviderConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProviderConfig, request, options: options);
  }

  // method descriptors

  static final _$getConfig =
      $grpc.ClientMethod<$0.GetConfigRequest, $0.GetConfigResponse>(
          '/fileguardian.v1.ConfigService/GetConfig',
          ($0.GetConfigRequest value) => value.writeToBuffer(),
          $0.GetConfigResponse.fromBuffer);
  static final _$listProviders =
      $grpc.ClientMethod<$0.ListProvidersRequest, $0.ListProvidersResponse>(
          '/fileguardian.v1.ConfigService/ListProviders',
          ($0.ListProvidersRequest value) => value.writeToBuffer(),
          $0.ListProvidersResponse.fromBuffer);
  static final _$updateProviderConfig = $grpc.ClientMethod<
          $0.UpdateProviderConfigRequest, $0.UpdateProviderConfigResponse>(
      '/fileguardian.v1.ConfigService/UpdateProviderConfig',
      ($0.UpdateProviderConfigRequest value) => value.writeToBuffer(),
      $0.UpdateProviderConfigResponse.fromBuffer);
}

@$pb.GrpcServiceName('fileguardian.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'fileguardian.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetConfigRequest, $0.GetConfigResponse>(
        'GetConfig',
        getConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetConfigRequest.fromBuffer(value),
        ($0.GetConfigResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListProvidersRequest, $0.ListProvidersResponse>(
            'ListProviders',
            listProviders_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListProvidersRequest.fromBuffer(value),
            ($0.ListProvidersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateProviderConfigRequest,
            $0.UpdateProviderConfigResponse>(
        'UpdateProviderConfig',
        updateProviderConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateProviderConfigRequest.fromBuffer(value),
        ($0.UpdateProviderConfigResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetConfigResponse> getConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetConfigRequest> $request) async {
    return getConfig($call, await $request);
  }

  $async.Future<$0.GetConfigResponse> getConfig(
      $grpc.ServiceCall call, $0.GetConfigRequest request);

  $async.Future<$0.ListProvidersResponse> listProviders_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListProvidersRequest> $request) async {
    return listProviders($call, await $request);
  }

  $async.Future<$0.ListProvidersResponse> listProviders(
      $grpc.ServiceCall call, $0.ListProvidersRequest request);

  $async.Future<$0.UpdateProviderConfigResponse> updateProviderConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateProviderConfigRequest> $request) async {
    return updateProviderConfig($call, await $request);
  }

  $async.Future<$0.UpdateProviderConfigResponse> updateProviderConfig(
      $grpc.ServiceCall call, $0.UpdateProviderConfigRequest request);
}
