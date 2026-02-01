import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_field_entity.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';
import 'package:guardian_ui/features/settings/domain/usecases/list_providers.dart';

class MockConfigRepository extends Mock implements ConfigRepository {}

void main() {
  late ListProviders useCase;
  late MockConfigRepository mockRepository;

  setUp(() {
    mockRepository = MockConfigRepository();
    useCase = ListProviders(repository: mockRepository);
  });

  final providers = [
    const ProviderEntity(
      name: 'S3',
      displayName: 'Amazon S3',
      active: true,
      fields: [
        ProviderFieldEntity(
          key: 'region',
          label: 'Region',
          type: FieldType.string,
          required: true,
          value: 'us-east-1',
          placeholder: 'us-east-1',
        ),
      ],
    ),
  ];

  test('returns provider list on success', () async {
    when(() => mockRepository.listProviders())
        .thenAnswer((_) async => Right(providers));

    final result = await useCase();

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('expected Right'),
      (data) {
        expect(data.length, 1);
        expect(data.first.name, 'S3');
      },
    );
  });

  test('returns failure on error', () async {
    when(() => mockRepository.listProviders())
        .thenAnswer((_) async => const Left(ServerUnavailableFailure('down')));

    final result = await useCase();

    expect(result.isLeft(), true);
  });
}
