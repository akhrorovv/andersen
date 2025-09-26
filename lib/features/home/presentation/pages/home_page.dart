import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/widgets/event_tile.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/features/home/presentation/pages/stop_activity_page.dart';
import 'package:andersen/features/home/presentation/widgets/kpi_for_week.dart';
import 'package:andersen/features/home/presentation/widgets/schedule.dart';
import 'package:andersen/features/home/presentation/widgets/upcoming_events.dart';
import 'package:andersen/features/home/presentation/widgets/tasks_for_today.dart';
import 'package:andersen/features/kpi/presentation/pages/kpi_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  static String path = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final formattedDate = DateFormat("EEEE, dd MMMM", locale).format(DateTime.now());

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
                      final label = state.status.isActive
                          ? context.tr('hasLeft')
                          : context.tr('hasCome');
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
                                  "${context.tr('gettingStarted')} - ${DateFormat.Hm().format(state.status.arrivedAt!.toLocal())}",
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
}
