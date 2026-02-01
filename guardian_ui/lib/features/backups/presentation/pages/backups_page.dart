import 'package:flutter/material.dart';

import 'package:guardian_ui/features/dashboard/presentation/widgets/empty_state.dart';

class BackupsPage extends StatelessWidget {
  const BackupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyState(
        icon: Icons.backup_outlined,
        title: 'Backups',
        subtitle: 'Backup management coming soon.',
      ),
    );
  }
}
