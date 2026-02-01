import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pbgrpc.dart';

class ProcessDetailRemoteDataSource {
  final UploadServiceClient client;

  const ProcessDetailRemoteDataSource({required this.client});

  Future<GetProcessResponse> getProcessDetail({
    required String processId,
  }) {
    return client.getProcess(
      GetProcessRequest()..processId = processId,
    );
  }
}
