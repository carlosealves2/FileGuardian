import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:guardian_ui/features/settings/domain/entities/provider_field_entity.dart';

class DynamicFieldWidget extends StatelessWidget {
  final ProviderFieldEntity field;
  final TextEditingController? controller;
  final bool? boolValue;
  final ValueChanged<bool>? onBoolChanged;

  const DynamicFieldWidget({
    super.key,
    required this.field,
    this.controller,
    this.boolValue,
    this.onBoolChanged,
  });

  @override
  Widget build(BuildContext context) {
    return switch (field.type) {
      FieldType.boolean => _buildBooleanField(context),
      FieldType.secret => _buildSecretField(context),
      FieldType.number => _buildNumberField(context),
      FieldType.string => _buildStringField(context),
    };
  }

  Widget _buildStringField(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder,
      ),
      validator: field.required ? _requiredValidator : null,
    );
  }

  Widget _buildSecretField(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.value.isEmpty
            ? field.placeholder
            : '••••••••',
      ),
      validator: field.required && field.value.isEmpty
          ? _requiredValidator
          : null,
    );
  }

  Widget _buildNumberField(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: field.required ? _requiredValidator : null,
    );
  }

  Widget _buildBooleanField(BuildContext context) {
    return SwitchListTile(
      title: Text(field.label),
      value: boolValue ?? false,
      onChanged: onBoolChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${field.label} is required';
    }
    return null;
  }
}
