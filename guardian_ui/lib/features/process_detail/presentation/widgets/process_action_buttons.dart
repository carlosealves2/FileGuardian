import 'package:flutter/material.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';

class ProcessActionButtons extends StatelessWidget {
  final ProcessStatus status;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const ProcessActionButtons({
    super.key,
    required this.status,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == ProcessStatus.inProgress)
          FilledButton.tonalIcon(
            onPressed: onPause,
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
          ),
        if (status == ProcessStatus.paused)
          FilledButton.tonalIcon(
            onPressed: onResume,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume'),
          ),
        if (status == ProcessStatus.inProgress ||
            status == ProcessStatus.paused ||
            status == ProcessStatus.pending) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ],
    );
  }
}
