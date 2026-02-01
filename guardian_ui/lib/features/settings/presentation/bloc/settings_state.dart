import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final ConfigEntity config;
  final List<ProviderEntity> providers;
  final bool isSaving;
  final String? saveError;
  final String? saveSuccess;

  const SettingsLoaded({
    required this.config,
    required this.providers,
    this.isSaving = false,
    this.saveError,
    this.saveSuccess,
  });

  SettingsLoaded copyWith({
    ConfigEntity? config,
    List<ProviderEntity>? providers,
    bool? isSaving,
    String? saveError,
    String? saveSuccess,
  }) {
    return SettingsLoaded(
      config: config ?? this.config,
      providers: providers ?? this.providers,
      isSaving: isSaving ?? this.isSaving,
      saveError: saveError,
      saveSuccess: saveSuccess,
    );
  }

  @override
  List<Object?> get props => [
        config,
        providers,
        isSaving,
        saveError,
        saveSuccess,
      ];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
