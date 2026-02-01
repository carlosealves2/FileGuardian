import 'package:flutter/material.dart';

import 'package:guardian_ui/core/theme/status_colors.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';

class StatusBadge extends StatelessWidget {
  final ProcessStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColors = Theme.of(context).extension<StatusColors>()!;
    final color = _colorForStatus(statusColors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _colorForStatus(StatusColors colors) {
    return switch (status) {
      ProcessStatus.pending => colors.pending,
      ProcessStatus.inProgress => colors.inProgress,
      ProcessStatus.paused => colors.paused,
      ProcessStatus.completed => colors.completed,
      ProcessStatus.failed => colors.failed,
      ProcessStatus.cancelled => colors.cancelled,
    };
  }

  String get _label {
    return switch (status) {
      ProcessStatus.pending => 'Pending',
      ProcessStatus.inProgress => 'In Progress',
      ProcessStatus.paused => 'Paused',
      ProcessStatus.completed => 'Completed',
      ProcessStatus.failed => 'Failed',
      ProcessStatus.cancelled => 'Cancelled',
    };
  }
}
