import 'package:grpc/grpc.dart';

import 'package:guardian_ui/generated/proto/fileguardian/v1/upload_service.pbgrpc.dart';

class UploadRemoteDataSource {
  final UploadServiceClient client;

  const UploadRemoteDataSource({required this.client});

  Future<ListProcessesResponse> listProcesses({
    required String cursor,
    required int limit,
  }) {
    return client.listProcesses(
      ListProcessesRequest()
        ..cursor = cursor
        ..limit = limit,
    );
  }

  ResponseStream<UploadFileResponse> uploadFile({required String filePath}) {
    return client.uploadFile(
      UploadFileRequest()..filePath = filePath,
    );
  }

  ResponseStream<UploadFolderResponse> uploadFolder({
    required String folderPath,
  }) {
    return client.uploadFolder(
      UploadFolderRequest()..folderPath = folderPath,
    );
  }

  Future<PauseProcessResponse> pauseProcess({required String processId}) {
    return client.pauseProcess(
      PauseProcessRequest()..processId = processId,
    );
  }

  ResponseStream<ResumeProcessResponse> resumeProcess({
    required String processId,
  }) {
    return client.resumeProcess(
      ResumeProcessRequest()..processId = processId,
    );
  }

  Future<CancelProcessResponse> cancelProcess({required String processId}) {
    return client.cancelProcess(
      CancelProcessRequest()..processId = processId,
    );
  }
}
