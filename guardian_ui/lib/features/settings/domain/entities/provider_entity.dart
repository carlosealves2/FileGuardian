import 'package:equatable/equatable.dart';

import 'provider_field_entity.dart';

class ProviderEntity extends Equatable {
  final String name;
  final String displayName;
  final bool active;
  final List<ProviderFieldEntity> fields;

  const ProviderEntity({
    required this.name,
    required this.displayName,
    required this.active,
    required this.fields,
  });

  @override
  List<Object?> get props => [name, displayName, active, fields];
}
