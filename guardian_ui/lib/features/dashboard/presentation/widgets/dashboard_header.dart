import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_event.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor and manage your backups',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _StartBackupButton(),
      ],
    );
  }
}

class _StartBackupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.insert_drive_file_outlined),
          onPressed: () => _pickFile(context),
          child: const Text('Upload File'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.folder_outlined),
          onPressed: () => _pickFolder(context),
          child: const Text('Upload Folder'),
        ),
      ],
      builder: (context, controller, child) {
        return FilledButton.icon(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.backup_outlined, size: 18),
          label: const Text('Start Backup'),
        );
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    if (!context.mounted) return;

    final path = result.files.single.path;
    if (path == null) return;

    context.read<UploadBloc>().add(UploadFileRequested(filePath: path));
  }

  Future<void> _pickFolder(BuildContext context) async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    if (!context.mounted) return;

    context.read<UploadBloc>().add(UploadFolderRequested(folderPath: path));
  }
}
