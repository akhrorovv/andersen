import 'package:andersen/core/common/profile/cubit/profile_cubit.dart';
import 'package:andersen/features/activities/presentation/cubit/activity_detail_cubit.dart';
import 'package:andersen/features/activities/presentation/pages/activity_detail_page.dart';
import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/auth/presentation/pages/splash_page.dart';
import 'package:andersen/features/activities/presentation/pages/activities_page.dart';
import 'package:andersen/features/calendar/presentation/cubit/delete_event_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/event_detail_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/pages/calendar_page.dart';
import 'package:andersen/features/calendar/presentation/pages/event_detail_page.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/stop_activity_cubit.dart';
import 'package:andersen/features/home/presentation/pages/languages_page.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:andersen/features/home/presentation/pages/stop_activity_page.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/pages/kpi_page.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'package:andersen/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:andersen/features/tasks/presentation/pages/tasks_page.dart';
import 'package:andersen/features/main_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_start_modal_bottomsheet.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: SplashPage.path,
  navigatorKey: navigatorKey,
  routes: [
    /// Splash page
    GoRoute(
      path: SplashPage.path,
      builder: (context, state) {
        return BlocProvider(create: (_) => sl<ProfileCubit>()..getProfile(), child: SplashPage());
      },
    ),

    /// Login page
    GoRoute(
      path: LoginPage.path,
      builder: (context, state) {
        return BlocProvider(create: (_) => sl<AuthCubit>(), child: LoginPage());
      },
    ),

    /// Checking page
    GoRoute(path: CheckingPage.path, builder: (context, state) => CheckingPage()),

    /// Main page
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainPage(navigationShell: navigationShell),
      branches: [
        /// Home page
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomePage.path,
              builder: (context, state) {
                return BlocProvider(
                  create: (_) => sl<ProfileCubit>()..getProfile(),
                  child: HomePage(),
                );
              },
            ),
          ],
        ),

        /// Tasks page
        StatefulShellBranch(
          routes: [GoRoute(path: TasksPage.path, builder: (context, state) => TasksPage())],
        ),

        /// Calendar page
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: CalendarPage.path,
              builder: (context, state) {
                return BlocProvider(
                  create: (_) => sl<EventsCubit>()..getEvents(focusedDay: DateTime.now()),
                  child: CalendarPage(),
                );
              },
            ),
          ],
        ),

        /// Activities page
        StatefulShellBranch(
          routes: [
            GoRoute(path: ActivitiesPage.path, builder: (context, state) => ActivitiesPage()),
          ],
        ),

        /// Kpi page
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: KpiPage.path,
              builder: (context, state) => BlocProvider(
                create: (_) => sl<KpiUserCubit>()..getUserKpi(111),
                child: KpiPage(),
              ),
            ),
          ],
        ),
      ],
    ),

    GoRoute(path: ReasonPage.path, builder: (context, state) => ReasonPage()),
    GoRoute(path: LanguagesPage.path, builder: (context, state) => LanguagesPage()),
    GoRoute(
      path: ActivityStartModalBottomSheet.path,
      builder: (context, state) => ActivityStartModalBottomSheet(),
    ),

    GoRoute(
      path: StopActivityPage.path,
      builder: (context, state) {
        final activityId = state.extra as int;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ActivityStatusCubit>()..checkActiveActivity()),
            BlocProvider(create: (_) => sl<StopActivityCubit>()),
          ],
          child: StopActivityPage(activityId: activityId),
        );
      },
    ),

    GoRoute(
      path: TaskDetailPage.path,
      builder: (context, state) {
        final taskId = state.extra as int;
        return BlocProvider.value(
          value: sl<TaskDetailCubit>()..getTaskDetail(taskId),
          child: TaskDetailPage(taskId: taskId),
        );
      },
    ),

    GoRoute(
      path: EventDetailPage.path,
      builder: (context, state) {
        final eventId = state.extra as int;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<EventDetailCubit>()..getEventDetail(eventId)),
            BlocProvider(create: (_) => sl<DeleteEventCubit>()),
          ],
          child: EventDetailPage(eventId: eventId),
        );
      },
    ),

    GoRoute(
      path: ActivityDetailPage.path,
      builder: (context, state) {
        final activityId = state.extra as int;
        return BlocProvider.value(
          value: sl<ActivityDetailCubit>()..getActivityDetail(activityId),
          child: ActivityDetailPage(activityId: activityId),
        );
      },
    ),
  ],
);

extension CupertinoSheetExtension on BuildContext {
  Future<T?> pushCupertinoSheet<T>(Widget page) {
    return Navigator.of(this, rootNavigator: true).push(CupertinoSheetRoute(builder: (_) => page));
  }
}
