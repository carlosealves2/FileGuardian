import 'package:flutter/material.dart';

import 'package:guardian_ui/features/settings/domain/entities/provider_entity.dart';
import 'package:guardian_ui/features/settings/domain/entities/provider_field_entity.dart';
import 'package:guardian_ui/features/settings/presentation/widgets/dynamic_field_widget.dart';

class ProviderCard extends StatefulWidget {
  final ProviderEntity provider;
  final bool isSaving;
  final void Function(Map<String, String> fields, bool setActive) onSave;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, bool> _boolValues;
  bool _setActive = false;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _boolValues = {};
    _setActive = widget.provider.active;

    for (final field in widget.provider.fields) {
      if (field.type == FieldType.boolean) {
        _boolValues[field.key] = field.value == 'true';
      } else {
        _controllers[field.key] = TextEditingController(text: field.value);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final fields = <String, String>{};
    for (final field in widget.provider.fields) {
      if (field.type == FieldType.boolean) {
        fields[field.key] = (_boolValues[field.key] ?? false).toString();
      } else {
        fields[field.key] = _controllers[field.key]?.text ?? '';
      }
    }

    widget.onSave(fields, _setActive);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.provider.displayName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (widget.provider.active)
                    Chip(
                      label: const Text('Active'),
                      backgroundColor:
                          theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      side: BorderSide.none,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...widget.provider.fields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DynamicFieldWidget(
                      field: field,
                      controller: _controllers[field.key],
                      boolValue: _boolValues[field.key],
                      onBoolChanged: (value) {
                        setState(() {
                          _boolValues[field.key] = value;
                        });
                      },
                    ),
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (!widget.provider.active) ...[
                    FilterChip(
                      label: const Text('Set as active'),
                      selected: _setActive,
                      onSelected: (v) => setState(() => _setActive = v),
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),
                  FilledButton.icon(
                    onPressed: widget.isSaving ? null : _handleSave,
                    icon: widget.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
