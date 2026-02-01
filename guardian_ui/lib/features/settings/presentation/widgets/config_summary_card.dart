import 'package:flutter/material.dart';

import 'package:guardian_ui/features/settings/domain/entities/config_entity.dart';

class ConfigSummaryCard extends StatelessWidget {
  final ConfigEntity config;

  const ConfigSummaryCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Configuration',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildRow(
              context,
              icon: Icons.cloud_outlined,
              label: 'Active Provider',
              value: config.activeProvider.isEmpty
                  ? 'Not configured'
                  : config.activeProvider,
            ),
            const SizedBox(height: 8),
            _buildRow(
              context,
              icon: Icons.straighten_outlined,
              label: 'Part Size',
              value: _formatBytes(config.uploadPartSize),
            ),
            const SizedBox(height: 8),
            _buildRow(
              context,
              icon: Icons.sync_outlined,
              label: 'Max Concurrent',
              value: config.uploadMaxConcurrent.toString(),
            ),
            const SizedBox(height: 8),
            _buildRow(
              context,
              icon: Icons.lan_outlined,
              label: 'gRPC Port',
              value: config.grpcPort.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}
