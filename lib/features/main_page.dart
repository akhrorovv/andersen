import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  static String path = '/main';
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationShell.goBranch,
        currentIndex: navigationShell.currentIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.sp,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.vectors.home.path),
            activeIcon: SvgPicture.asset(Assets.vectors.homeActive.path),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.vectors.tasks.path),
            activeIcon: SvgPicture.asset(Assets.vectors.tasksActive.path),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.vectors.calendar.path),
            activeIcon: SvgPicture.asset(Assets.vectors.calendarActive.path),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.vectors.activities.path),
            activeIcon: SvgPicture.asset(Assets.vectors.activitiesActive.path),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.vectors.kpi.path),
            activeIcon: SvgPicture.asset(Assets.vectors.kpiActive.path),
            label: 'KPI',
          ),
        ],
      ),
    );
  }
}
