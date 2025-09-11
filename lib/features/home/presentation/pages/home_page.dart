import 'package:andersen/core/common/navigation/navigation_helper.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  static String path = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat("EEEE, dd MMMM", locale).format(now);
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider(
                create: (context) => sl<HomeCubit>()..loadUserAndStatus(),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is HomeLoaded) {
                      final label = state.status.isActive
                          ? "Has Left"
                          : "Has Come";
                      return ShadowContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${DBService.user!.name}",
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
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
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
                                if (state.status.isActive)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 12.w,
                                      top: 12.h,
                                    ),
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
                              ],
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
                    } else if (state is HomeError) {
                      return Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),

              _upcomingEventText(),

              ShadowContainer(child: Column()),

              _tasksText(),

              ShadowContainer(child: Column()),

              _kpiForWeekText(),

              ShadowContainer(child: Column()),

              _scheduleText(),

              ShadowContainer(child: Column()),
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
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: AppColors.colorText,
        ),
      ),
    );
  }

  Widget _tasksText() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        'Tasks',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: AppColors.colorText,
        ),
      ),
    );
  }

  Widget _kpiForWeekText() {
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
          Text(
            'More',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              decoration: TextDecoration.underline,
              color: AppColors.colorText,
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
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: AppColors.colorText,
        ),
      ),
    );
  }
}
