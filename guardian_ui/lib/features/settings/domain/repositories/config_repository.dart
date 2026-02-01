import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';

abstract class ConfigRepository {
  Future<Either<Failure, ConfigEntity>> getConfig();
  Future<Either<Failure, List<ProviderEntity>>> listProviders();
  Future<Either<Failure, void>> updateProviderConfig({
    required String provider,
    required Map<String, String> fields,
    required bool setActive,
  });
}
