import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/core/di/injection.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_event.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_state.dart';
import 'package:guardian_ui/features/settings/presentation/widgets/config_summary_card.dart';
import 'package:guardian_ui/features/settings/presentation/widgets/provider_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SettingsBloc>()..add(const SettingsLoadRequested()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            if (state.saveSuccess != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.saveSuccess!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state.saveError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.saveError!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return switch (state) {
            SettingsInitial() || SettingsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            SettingsError(:final message) => _ErrorView(
                message: message,
                onRetry: () => context
                    .read<SettingsBloc>()
                    .add(const SettingsLoadRequested()),
              ),
            SettingsLoaded() => _LoadedView(state: state),
          };
        },
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final SettingsLoaded state;

  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConfigSummaryCard(config: state.config),
            const SizedBox(height: 24),
            Text(
              'Storage Providers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...state.providers.map((provider) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ProviderCard(
                    provider: provider,
                    isSaving: state.isSaving,
                    onSave: (fields, setActive) {
                      context.read<SettingsBloc>().add(
                            SettingsProviderConfigSaved(
                              provider: provider.name,
                              fields: fields,
                              setActive: setActive,
                            ),
                          );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
