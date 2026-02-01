import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'sidebar_nav_item.dart';

class AppSidebar extends StatelessWidget {
  final String currentLocation;

  const AppSidebar({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _indexFromLocation(currentLocation);

    return Container(
      width: 220,
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AWS Backup Tool',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Simple & Secure',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SidebarNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  selected: selectedIndex == 0,
                  onTap: () => context.go('/'),
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: Icons.backup_outlined,
                  selectedIcon: Icons.backup,
                  label: 'Backups',
                  selected: selectedIndex == 1,
                  onTap: () => context.go('/backups'),
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: Icons.history_outlined,
                  selectedIcon: Icons.history,
                  label: 'History',
                  selected: selectedIndex == 2,
                  onTap: () => context.go('/history'),
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: 'Settings',
                  selected: selectedIndex == 3,
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/backups')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }
}
