import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';

class GetConfig {
  final ConfigRepository repository;

  const GetConfig({required this.repository});

  Future<Either<Failure, ConfigEntity>> call() {
    return repository.getConfig();
  }
}
