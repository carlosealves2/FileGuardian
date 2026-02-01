import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';

class ListProviders {
  final ConfigRepository repository;

  const ListProviders({required this.repository});

  Future<Either<Failure, List<ProviderEntity>>> call() {
    return repository.listProviders();
  }
}
