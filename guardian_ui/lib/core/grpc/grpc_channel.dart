import 'package:grpc/grpc.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/config_service.pbgrpc.dart';
import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pbgrpc.dart';

import 'interceptors/error_mapping_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class GrpcChannel {
  static const String _defaultHost = 'localhost';
  static const int _defaultPort = 50051;

  final ClientChannel channel;

  late final ConfigServiceClient configServiceClient;
  late final UploadServiceClient uploadServiceClient;

  GrpcChannel({
    String host = _defaultHost,
    int port = _defaultPort,
  }) : channel = ClientChannel(
          host,
          port: port,
          options: const ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        ) {
    final interceptors = [
      LoggingInterceptor(),
      ErrorMappingInterceptor(),
    ];

    configServiceClient = ConfigServiceClient(
      channel,
      interceptors: interceptors,
    );

    uploadServiceClient = UploadServiceClient(
      channel,
      interceptors: interceptors,
    );
  }

  Future<void> shutdown() async {
    await channel.shutdown();
  }
}
