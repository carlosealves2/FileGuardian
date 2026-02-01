import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';
import 'package:guardian_ui/features/settings/domain/usecases/get_config.dart';

class MockConfigRepository extends Mock implements ConfigRepository {}

void main() {
  late GetConfig useCase;
  late MockConfigRepository mockRepository;

  setUp(() {
    mockRepository = MockConfigRepository();
    useCase = GetConfig(repository: mockRepository);
  });

  const config = ConfigEntity(
    activeProvider: 'S3',
    uploadPartSize: 5242880,
    uploadMaxConcurrent: 3,
    grpcPort: 50051,
  );

  test('returns config on success', () async {
    when(() => mockRepository.getConfig())
        .thenAnswer((_) async => const Right(config));

    final result = await useCase();

    expect(result, const Right(config));
    verify(() => mockRepository.getConfig()).called(1);
  });

  test('returns failure on error', () async {
    when(() => mockRepository.getConfig())
        .thenAnswer((_) async => const Left(ServerFailure('error')));

    final result = await useCase();

    expect(result.isLeft(), true);
  });
}
