import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/core/grpc/interceptors/error_mapping_interceptor.dart';
import 'package:guardian_ui/features/dashboard/data/models/process_model.dart';
import 'package:guardian_ui/features/process_detail/data/datasources/process_detail_remote_datasource.dart';
import 'package:guardian_ui/features/process_detail/data/models/upload_model.dart';
import 'package:guardian_ui/features/process_detail/domain/repositories/process_detail_repository.dart';

class ProcessDetailRepositoryImpl implements ProcessDetailRepository {
  final ProcessDetailRemoteDataSource remoteDataSource;

  const ProcessDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProcessDetailResult>> getProcessDetail({
    required String processId,
  }) async {
    try {
      final response = await remoteDataSource.getProcessDetail(
        processId: processId,
      );
      return Right(ProcessDetailResult(
        process: ProcessModel.fromProto(response.process),
        uploads: response.uploads.map(UploadModel.fromProto).toList(),
      ));
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }
}
