import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/core/grpc/interceptors/error_mapping_interceptor.dart';
import 'package:guardian_ui/features/settings/data/datasources/config_remote_datasource.dart';
import 'package:guardian_ui/features/settings/data/models/config_model.dart';
import 'package:guardian_ui/features/settings/data/models/provider_model.dart';
import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigRemoteDataSource remoteDataSource;

  const ConfigRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ConfigEntity>> getConfig() async {
    try {
      final response = await remoteDataSource.getConfig();
      return Right(ConfigModel.fromProto(response));
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> listProviders() async {
    try {
      final response = await remoteDataSource.listProviders();
      final providers =
          response.providers.map(ProviderModel.fromProto).toList();
      return Right(providers);
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProviderConfig({
    required String provider,
    required Map<String, String> fields,
    required bool setActive,
  }) async {
    try {
      await remoteDataSource.updateProviderConfig(
        provider: provider,
        fields: fields,
        setActive: setActive,
      );
      return const Right(null);
    } on GrpcError catch (e) {
      return Left(ErrorMappingInterceptor.mapGrpcError(e));
    }
  }
}
