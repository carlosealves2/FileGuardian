import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/usecases/get_config.dart';
import 'package:guardian_ui/features/settings/domain/usecases/list_providers.dart';
import 'package:guardian_ui/features/settings/domain/usecases/update_provider_config.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_event.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_state.dart';

class MockGetConfig extends Mock implements GetConfig {}

class MockListProviders extends Mock implements ListProviders {}

class MockUpdateProviderConfig extends Mock implements UpdateProviderConfig {}

void main() {
  late MockGetConfig mockGetConfig;
  late MockListProviders mockListProviders;
  late MockUpdateProviderConfig mockUpdateProviderConfig;

  const config = ConfigEntity(
    activeProvider: 'S3',
    uploadPartSize: 5242880,
    uploadMaxConcurrent: 3,
    grpcPort: 50051,
  );

  const providers = <ProviderEntity>[
    ProviderEntity(
      name: 'S3',
      displayName: 'Amazon S3',
      active: true,
      fields: [],
    ),
  ];

  setUp(() {
    mockGetConfig = MockGetConfig();
    mockListProviders = MockListProviders();
    mockUpdateProviderConfig = MockUpdateProviderConfig();
  });

  SettingsBloc buildBloc() => SettingsBloc(
        getConfig: mockGetConfig,
        listProviders: mockListProviders,
        updateProviderConfig: mockUpdateProviderConfig,
      );

  group('SettingsLoadRequested', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits [Loading, Loaded] when both calls succeed',
      setUp: () {
        when(() => mockGetConfig()).thenAnswer(
          (_) async => const Right(config),
        );
        when(() => mockListProviders()).thenAnswer(
          (_) async => const Right(providers),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const SettingsLoadRequested()),
      expect: () => [
        const SettingsLoading(),
        const SettingsLoaded(config: config, providers: providers),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits [Loading, Error] when getConfig fails',
      setUp: () {
        when(() => mockGetConfig()).thenAnswer(
          (_) async => const Left(ServerFailure('failed')),
        );
        when(() => mockListProviders()).thenAnswer(
          (_) async => const Right(providers),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const SettingsLoadRequested()),
      expect: () => [
        const SettingsLoading(),
        const SettingsError('failed'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits [Loading, Error] when listProviders fails',
      setUp: () {
        when(() => mockGetConfig()).thenAnswer(
          (_) async => const Right(config),
        );
        when(() => mockListProviders()).thenAnswer(
          (_) async => const Left(ServerUnavailableFailure('down')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const SettingsLoadRequested()),
      expect: () => [
        const SettingsLoading(),
        const SettingsError('down'),
      ],
    );
  });

  group('SettingsProviderConfigSaved', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits saving then reloads on success',
      setUp: () {
        when(() => mockGetConfig()).thenAnswer(
          (_) async => const Right(config),
        );
        when(() => mockListProviders()).thenAnswer(
          (_) async => const Right(providers),
        );
        when(() => mockUpdateProviderConfig(
              provider: any(named: 'provider'),
              fields: any(named: 'fields'),
              setActive: any(named: 'setActive'),
            )).thenAnswer((_) async => const Right(null));
      },
      build: buildBloc,
      seed: () => const SettingsLoaded(config: config, providers: providers),
      act: (bloc) => bloc.add(const SettingsProviderConfigSaved(
        provider: 'S3',
        fields: {'region': 'us-west-2'},
        setActive: true,
      )),
      expect: () => [
        const SettingsLoaded(
          config: config,
          providers: providers,
          isSaving: true,
        ),
        const SettingsLoaded(
          config: config,
          providers: providers,
          saveSuccess: 'Configuration saved',
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits save error on failure',
      setUp: () {
        when(() => mockUpdateProviderConfig(
              provider: any(named: 'provider'),
              fields: any(named: 'fields'),
              setActive: any(named: 'setActive'),
            )).thenAnswer(
          (_) async => const Left(ValidationFailure('invalid region')),
        );
      },
      build: buildBloc,
      seed: () => const SettingsLoaded(config: config, providers: providers),
      act: (bloc) => bloc.add(const SettingsProviderConfigSaved(
        provider: 'S3',
        fields: {'region': ''},
        setActive: false,
      )),
      expect: () => [
        const SettingsLoaded(
          config: config,
          providers: providers,
          isSaving: true,
        ),
        const SettingsLoaded(
          config: config,
          providers: providers,
          isSaving: false,
          saveError: 'invalid region',
        ),
      ],
    );
  });
}
