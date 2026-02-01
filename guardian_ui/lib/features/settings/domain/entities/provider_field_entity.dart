import 'package:equatable/equatable.dart';

enum FieldType { string, secret, number, boolean }

class ProviderFieldEntity extends Equatable {
  final String key;
  final String label;
  final FieldType type;
  final bool required;
  final String value;
  final String placeholder;

  const ProviderFieldEntity({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.value,
    required this.placeholder,
  });

  @override
  List<Object?> get props => [key, label, type, required, value, placeholder];
}
