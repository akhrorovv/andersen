import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/features/home/presentation/pages/stop_activity_page.dart';
import 'package:andersen/features/home/presentation/widgets/today_events_section.dart';
import 'package:andersen/features/home/presentation/widgets/today_tasks_section.dart';
import 'package:andersen/features/kpi/presentation/pages/kpi_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static String path = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final locale = context.locale.languageCode;
    final formattedDate = DateFormat("EEEE, dd MMMM", locale).format(now);

    final List<DateTime> days = List.generate(5, (i) => now.add(Duration(days: i)));
    DateTime? selectedDate;

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
              BlocProvider(
                create: (context) => sl<HomeCubit>()..loadUserAndStatus(),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return LoadingIndicator();
                    } else if (state is HomeError) {
                      return ErrorWidget(state.message);
                    } else if (state is HomeLoaded) {
                      final label = state.status.isActive ? "Has Left" : "Has Come";
                      return ShadowContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${context.tr('hello')}, ${DBService.user?.name}",
                              style: TextStyle(
                                color: AppColors.colorPrimaryText,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2.h,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppColors.colorText,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.2.h,
                                letterSpacing: 0,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (state.status.isActive) {
                                      context.pushCupertinoSheet(const ReasonPage());
                                      // Has Left bo'lsa
                                      // context.read<HomeCubit>().leave();
                                    } else {
                                      context.pushCupertinoSheet(const ReasonPage());
                                      // Has Come bo'lsa
                                      // context.read<HomeCubit>().arrive();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                    margin: EdgeInsets.only(top: 12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: state.status.isActive
                                          ? Color(0xffFFD8BF)
                                          : Color(0xffD9F7BE),
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: state.status.isActive
                                            ? Color(0xffFF7A45)
                                            : Color(0xff389E0D),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.25.h,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      sl<ActivityStatusCubit>()..checkActiveActivity(),
                                  child: BlocBuilder<ActivityStatusCubit, ActivityStatusState>(
                                    builder: (context, state) {
                                      String timeText = "00:00:00";
                                      VoidCallback? onTap;

                                      if (state is ActivityStatusActive) {
                                        timeText = formatDuration(state.elapsedSeconds);
                                        // onTap = () => context.push(StopActivityPage.path);
                                        onTap = () {
                                          context.push(
                                            StopActivityPage.path,
                                            extra: context.read<ActivityStatusCubit>(),
                                          );
                                        };
                                      } else if (state is ActivityStatusInactive) {
                                        timeText = "00:00:00";
                                        onTap = () {};
                                      } else if (state is ActivityStatusLoading) {
                                        timeText = "Loading...";
                                      } else if (state is ActivityStatusError) {
                                        timeText = "Error";
                                      }

                                      return GestureDetector(
                                        onTap: onTap,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 10.h,
                                          ),
                                          margin: EdgeInsets.only(top: 12.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.r),
                                            border: Border.all(width: 1.w, color: AppColors.grey),
                                            color: AppColors.white,
                                          ),
                                          child: Row(
                                            spacing: 4.w,
                                            children: [
                                              const Icon(Icons.play_arrow),
                                              Text(
                                                timeText,
                                                style: TextStyle(
                                                  color: AppColors.colorText,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.25.h,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (state.status.isActive)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Text(
                                  "Getting started - ${DateFormat.Hm().format(state.status.arrivedAt!.toLocal())}",
                                  style: TextStyle(
                                    color: AppColors.colorText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2.h,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            if (!state.status.isActive)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Text(
                                  "To get started, please click on the \"Has come\" button!",
                                  style: TextStyle(
                                    color: AppColors.colorBgMask,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2.h,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),

              _upcomingEventText(),

              BlocProvider(
                create: (context) => sl<EventsCubit>()
                  ..getEvents(
                    todayMin: '${startOfDay.toIso8601String()}Z',
                    todayMax: '${endOfDay.toIso8601String()}Z',
                  ),
                child: BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsLoading) return const LoadingIndicator();
                    if (state is EventsError) return ErrorWidget(state.message);
                    if (state is EventsLoaded) {
                      return TodayEventsList(events: state.events.events);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              _tasksText(),

              TodayTasksSection(),

              _kpiForWeekText(context),

              ShadowContainer(child: Column()),

              _scheduleText(),

              ShadowContainer(
                child: Column(
                  children: [
                    /// Sanalar
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: days.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final date = days[index];
                          final isSelected = date == selectedDate;

                          final label = index == 0
                              ? "today"
                              : DateFormat('EEE d', locale).format(date);

                          return GestureDetector(
                            onTap: () {
                              // setState(() => selectedDate = date);
                              // _fetchEventsFor(date);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// eventlar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingEventText() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        'Upcoming event',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.colorText),
      ),
    );
  }

  Widget _tasksText() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        'Tasks',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.colorText),
      ),
    );
  }

  Widget _kpiForWeekText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KPI for week',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.colorText,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go(KpiPage.path);
            },
            child: Text(
              'More',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                decoration: TextDecoration.underline,
                color: AppColors.colorText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleText() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        'Schedule',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.colorText),
      ),
    );
  }
}
