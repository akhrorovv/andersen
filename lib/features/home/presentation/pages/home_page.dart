import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/features/home/presentation/widgets/home_header.dart';
import 'package:andersen/features/home/presentation/widgets/kpi_for_week.dart';
import 'package:andersen/features/home/presentation/widgets/schedule.dart';
import 'package:andersen/features/home/presentation/widgets/upcoming_events.dart';
import 'package:andersen/features/home/presentation/widgets/tasks_for_today.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  static String path = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial || state is HomeLoading) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        } else if (state is HomeError) {
          return Expanded(child: ErrorMessage(errorMessage: state.message));
        } else if (state is HomeLoaded) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Assets.images.title.image(width: 125.w),
              leading: GestureDetector(
                onTap: () => context.pushCupertinoSheet(const SettingsPage()),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: SvgPicture.asset(Assets.vectors.setting.path),
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  width: 44.w,
                  height: 44.w,
                  child: SvgPicture.asset(Assets.vectors.notification.path),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Home header
                    HomeHeader(),

                    /// Upcoming events
                    UpcomingEvents(),

                    /// Tasks for today
                    TasksForToday(),

                    /// Kpi for week
                    KpiForWeek(),

                    /// Schedule
                    Schedule(),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
