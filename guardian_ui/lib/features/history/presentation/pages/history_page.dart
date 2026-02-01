import 'package:flutter/material.dart';

import 'package:guardian_ui/features/dashboard/presentation/widgets/empty_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyState(
        icon: Icons.history_outlined,
        title: 'History',
        subtitle: 'Backup history coming soon.',
      ),
    );
  }
}
