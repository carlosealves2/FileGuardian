import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/settings/domain/usecases/get_config.dart';
import 'package:guardian_ui/features/settings/domain/usecases/list_providers.dart';
import 'package:guardian_ui/features/settings/domain/usecases/update_provider_config.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetConfig getConfig;
  final ListProviders listProviders;
  final UpdateProviderConfig updateProviderConfig;

  SettingsBloc({
    required this.getConfig,
    required this.listProviders,
    required this.updateProviderConfig,
  }) : super(const SettingsInitial()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsProviderConfigSaved>(_onProviderConfigSaved);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final configResult = await getConfig();
    final providersResult = await listProviders();

    final configEither = configResult;
    final providersEither = providersResult;

    configEither.fold(
      (failure) => emit(SettingsError(failure.message)),
      (config) => providersEither.fold(
        (failure) => emit(SettingsError(failure.message)),
        (providers) => emit(SettingsLoaded(
          config: config,
          providers: providers,
        )),
      ),
    );
  }

  Future<void> _onProviderConfigSaved(
    SettingsProviderConfigSaved event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    emit(currentState.copyWith(isSaving: true));

    final result = await updateProviderConfig(
      provider: event.provider,
      fields: event.fields,
      setActive: event.setActive,
    );

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(currentState.copyWith(
        isSaving: false,
        saveError: failure.message,
      ));
      return;
    }

    // Reload data after successful save
    final configResult = await getConfig();
    final providersResult = await listProviders();

    final config = configResult.getOrElse((_) => currentState.config);
    final providers =
        providersResult.getOrElse((_) => currentState.providers);

    emit(SettingsLoaded(
      config: config,
      providers: providers,
      saveSuccess: 'Configuration saved',
    ));
  }
}
