import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/network/connectivity_cubit.dart';
import 'package:andersen/core/network/connectivity_state.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/domain/repositories/complaints_repository.dart';
import 'package:andersen/features/kpi/presentation/cubit/complaints_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/complaints_state.dart';
import 'package:andersen/features/kpi/presentation/widgets/complaint_tile.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Complaints extends StatelessWidget {
  final String startDate;
  final String endDate;

  const Complaints({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final user = DBService.user;
    return BlocProvider(
      create: (_) => sl<ComplaintsCubit>()
        ..getComplaints(
          request: ComplaintsRequest(
            limit: 10,
            offset: 0,
            userId: user!.id,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, connectivityState) {
          if (connectivityState is RetryRequested) {
            context.read<ComplaintsCubit>().getComplaints(
              request: ComplaintsRequest(
                limit: 10,
                offset: 0,
                userId: user!.id,
                startDate: startDate,
                endDate: endDate,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: BasicAppBar(title: context.tr('complaint')),
          body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
            builder: (context, state) {
              if (state is ComplaintsInitial || state is ComplaintsLoading) {
                return LoadingIndicator();
              } else if (state is ComplaintsError) {
                return Center(child: ErrorMessage(errorMessage: state.message));
              } else if (state is ComplaintsLoaded) {
                final complaints = state.complaints.results;
                final count = complaints.length;
                if (count == 0) {
                  return EmptyWidget();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                  child: Column(
                    children: [
                      ShadowContainer(
                        child: Column(
                          spacing: 8.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('complaint'),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.2.h,
                                letterSpacing: 0,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.2.h,
                                letterSpacing: 0,
                                color: AppColors.colorText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 200) {
                              context.read<ComplaintsCubit>().loadMore();
                            }
                            return false;
                          },
                          child: RefreshIndicator(
                            color: AppColors.primary,
                            backgroundColor: Colors.white,
                            displacement: 50.h,
                            strokeWidth: 3,
                            onRefresh: () async {
                              await context.read<ComplaintsCubit>().getComplaints(
                                refresh: true,
                                request: ComplaintsRequest(
                                  limit: 10,
                                  offset: 0,
                                  userId: user!.id,
                                  startDate: startDate,
                                  endDate: endDate,
                                ),
                              );
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              itemBuilder: (context, index) {
                                return ComplaintTile(complaint: complaints[index]);
                              },
                              separatorBuilder: (_, __) => BasicDivider(),
                              itemCount: complaints.length,
                            ),
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
      ),
    );
  }
}
