import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/home/presentation/cubit/attendee_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:andersen/features/home/presentation/pages/settings_page.dart';
import 'package:andersen/features/home/presentation/widgets/home_header.dart';
import 'package:andersen/features/home/presentation/widgets/kpi_for_week.dart';
import 'package:andersen/features/home/presentation/widgets/schedule.dart';
import 'package:andersen/features/home/presentation/widgets/upcoming_events.dart';
import 'package:andersen/features/home/presentation/widgets/tasks_for_today.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/cupertino.dart';
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
              body: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                displacement: 80, // qancha pastga tushgandan keyin trigger bo‘lsin
                strokeWidth: 2.5,
                onRefresh: () async {
                  await context.read<HomeCubit>().getProfile();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          BlocProvider(
                            create: (_) => sl<AttendeeCubit>()..checkAttendeeStatus(),
                            child: HomeHeader(user: state.user),
                          ),
                          UpcomingEvents(),
                          TasksForToday(),
                          KpiForWeek(),
                          Schedule(),
                        ]),
                      ),
                    ),
                  ],
                ),
              )


          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
