import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/auth/presentation/pages/splash_page.dart';
import 'package:andersen/features/activities_page.dart';
import 'package:andersen/features/calendar_page.dart';
import 'package:andersen/features/kpi_page.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/features/tasks/presentation/pages/tasks_page.dart';
import 'package:andersen/features/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: SplashPage.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomePage.path,
              builder: (context, state) => HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: TasksPage.path,
              builder: (context, state) => TasksPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: CalendarPage.path,
              builder: (context, state) => CalendarPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ActivitiesPage.path,
              builder: (context, state) => ActivitiesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: KpiPage.path, builder: (context, state) => KpiPage()),
          ],
        ),
      ],
    ),
    GoRoute(path: SplashPage.path, builder: (context, state) => SplashPage()),
    GoRoute(path: LoginPage.path, builder: (context, state) => LoginPage()),
    GoRoute(
      path: SettingsPage.path,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1), // pastdan chiqadi
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          barrierDismissible: true,
          // tashqariga bosganda yopiladi
          opaque: false, // orqa sahifa ko‘rinib turadi
        );
      },
    ),
  ],
);

extension CupertinoSheetExtension on BuildContext {
  Future<T?> pushCupertinoSheet<T>(Widget page) {
    return Navigator.of(
      this,
      rootNavigator: true,
    ).push(CupertinoSheetRoute(builder: (_) => page));
  }
}
