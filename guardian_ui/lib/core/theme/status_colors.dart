import 'package:flutter/material.dart';

class StatusColors extends ThemeExtension<StatusColors> {
  final Color pending;
  final Color inProgress;
  final Color paused;
  final Color completed;
  final Color failed;
  final Color cancelled;

  const StatusColors({
    required this.pending,
    required this.inProgress,
    required this.paused,
    required this.completed,
    required this.failed,
    required this.cancelled,
  });

  static const light = StatusColors(
    pending: Color(0xFF9E9E9E),
    inProgress: Color(0xFF1E88E5),
    paused: Color(0xFFFB8C00),
    completed: Color(0xFF43A047),
    failed: Color(0xFFE53935),
    cancelled: Color(0xFF757575),
  );

  static const dark = StatusColors(
    pending: Color(0xFFBDBDBD),
    inProgress: Color(0xFF42A5F5),
    paused: Color(0xFFFFA726),
    completed: Color(0xFF66BB6A),
    failed: Color(0xFFEF5350),
    cancelled: Color(0xFF9E9E9E),
  );

  @override
  StatusColors copyWith({
    Color? pending,
    Color? inProgress,
    Color? paused,
    Color? completed,
    Color? failed,
    Color? cancelled,
  }) {
    return StatusColors(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      paused: paused ?? this.paused,
      completed: completed ?? this.completed,
      failed: failed ?? this.failed,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      pending: Color.lerp(pending, other.pending, t)!,
      inProgress: Color.lerp(inProgress, other.inProgress, t)!,
      paused: Color.lerp(paused, other.paused, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
      failed: Color.lerp(failed, other.failed, t)!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
    );
  }
}
