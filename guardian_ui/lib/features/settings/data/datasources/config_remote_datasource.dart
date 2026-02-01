import 'package:guardian_ui/generated/proto/fileguardian/v1/config_service.pbgrpc.dart';

class ConfigRemoteDataSource {
  final ConfigServiceClient client;

  const ConfigRemoteDataSource({required this.client});

  Future<GetConfigResponse> getConfig() {
    return client.getConfig(GetConfigRequest());
  }

  Future<ListProvidersResponse> listProviders() {
    return client.listProviders(ListProvidersRequest());
  }

  Future<UpdateProviderConfigResponse> updateProviderConfig({
    required String provider,
    required Map<String, String> fields,
    required bool setActive,
  }) {
    final fieldValues = fields.entries
        .map((e) => ProviderFieldValue()
          ..key = e.key
          ..value = e.value)
        .toList();

    return client.updateProviderConfig(
      UpdateProviderConfigRequest()
        ..provider = provider
        ..fields.addAll(fieldValues)
        ..setActive = setActive,
    );
  }
}
