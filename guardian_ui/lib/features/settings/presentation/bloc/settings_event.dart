sealed class SettingsEvent {
  const SettingsEvent();
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

class SettingsProviderConfigSaved extends SettingsEvent {
  final String provider;
  final Map<String, String> fields;
  final bool setActive;

  const SettingsProviderConfigSaved({
    required this.provider,
    required this.fields,
    required this.setActive,
  });
}
