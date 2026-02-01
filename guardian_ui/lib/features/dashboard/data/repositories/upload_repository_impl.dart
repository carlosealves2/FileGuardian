import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/core/grpc/interceptors/error_mapping_interceptor.dart';
import 'package:guardian_ui/features/dashboard/data/datasources/upload_remote_datasource.dart';
import 'package:guardian_ui/features/dashboard/data/models/process_model.dart';
import 'package:guardian_ui/features/dashboard/data/models/upload_progress_model.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  const UploadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProcessListResult>> listProcesses({
    required String cursor,
    required int limit,
  }) async {
    try {
      final response = await remoteDataSource.listProcesses(
        cursor: cursor,
        limit: limit,
      );
      final processes =
          response.processes.map(ProcessModel.fromProto).toList();
      return Right(ProcessListResult(
        processes: processes,
        nextCursor: response.nextCursor,
      ));
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }

  @override
  Stream<Either<Failure, UploadProgressEntity>> uploadFile({
    required String filePath,
  }) {
    return remoteDataSource
        .uploadFile(filePath: filePath)
        .map<Either<Failure, UploadProgressEntity>>(
          (response) =>
              Right(UploadProgressModel.fromProto(response.progress)),
        )
        .handleError(
          (Object error) => error is GrpcError
              ? Left(ErrorMappingInterceptor.mapGrpcError(error))
              : Left(ServerFailure(error.toString())),
        );
  }

  @override
  Stream<Either<Failure, UploadProgressEntity>> uploadFolder({
    required String folderPath,
  }) {
    return remoteDataSource
        .uploadFolder(folderPath: folderPath)
        .map<Either<Failure, UploadProgressEntity>>(
          (response) =>
              Right(UploadProgressModel.fromProto(response.progress)),
        )
        .handleError(
          (Object error) => error is GrpcError
              ? Left(ErrorMappingInterceptor.mapGrpcError(error))
              : Left(ServerFailure(error.toString())),
        );
  }

  @override
  Future<Either<Failure, void>> pauseProcess({
    required String processId,
  }) async {
    try {
      await remoteDataSource.pauseProcess(processId: processId);
      return const Right(null);
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }

  @override
  Stream<Either<Failure, UploadProgressEntity>> resumeProcess({
    required String processId,
  }) {
    return remoteDataSource
        .resumeProcess(processId: processId)
        .map<Either<Failure, UploadProgressEntity>>(
          (response) =>
              Right(UploadProgressModel.fromProto(response.progress)),
        )
        .handleError(
          (Object error) => error is GrpcError
              ? Left(ErrorMappingInterceptor.mapGrpcError(error))
              : Left(ServerFailure(error.toString())),
        );
  }

  @override
  Future<Either<Failure, void>> cancelProcess({
    required String processId,
  }) async {
    try {
      await remoteDataSource.cancelProcess(processId: processId);
      return const Right(null);
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }
}
