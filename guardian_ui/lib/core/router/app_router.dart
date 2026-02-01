import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:guardian_ui/core/di/injection.dart';
import 'package:guardian_ui/core/router/widgets/app_sidebar.dart';
import 'package:guardian_ui/features/backups/presentation/pages/backups_page.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:guardian_ui/features/history/presentation/pages/history_page.dart';
import 'package:guardian_ui/features/process_detail/presentation/pages/process_detail_page.dart';
import 'package:guardian_ui/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/backups',
            name: 'backups',
            builder: (context, state) => const BackupsPage(),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: '/process/:id',
            name: 'processDetail',
            builder: (context, state) {
              final processId = state.pathParameters['id']!;
              return ProcessDetailPage(processId: processId);
            },
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatelessWidget {
  final Widget child;

  const _ShellScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProcessListBloc>.value(
          value: getIt<ProcessListBloc>(),
        ),
        BlocProvider<UploadBloc>.value(
          value: getIt<UploadBloc>(),
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            AppSidebar(currentLocation: location),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
