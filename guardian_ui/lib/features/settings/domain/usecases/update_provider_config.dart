import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';

class UpdateProviderConfig {
  final ConfigRepository repository;

  const UpdateProviderConfig({required this.repository});

  Future<Either<Failure, void>> call({
    required String provider,
    required Map<String, String> fields,
    required bool setActive,
  }) {
    return repository.updateProviderConfig(
      provider: provider,
      fields: fields,
      setActive: setActive,
    );
  }
}
