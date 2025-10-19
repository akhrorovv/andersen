import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_repository.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_user_repository.dart';
import 'package:andersen/features/kpi/domain/repositories/workload_repository.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/workload_cubit.dart';
import 'package:andersen/features/kpi/presentation/widgets/actual_plan_table.dart';
import 'package:andersen/features/kpi/presentation/widgets/kpi_bar_chart.dart';
import 'package:andersen/features/kpi/presentation/widgets/user_kpi_section.dart';
import 'package:andersen/features/kpi/presentation/widgets/workload_chart.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpiPage extends StatefulWidget {
  static String path = '/kpi';

  const KpiPage({super.key});

  @override
  State<KpiPage> createState() => _KpiPageState();
}

class _KpiPageState extends State<KpiPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // init fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final user = DBService.user!;
    context.read<KpiCubit>().geKpi(
      KpiRequest(
        limit: 20,
        offset: 0,
        userId: user.id,
        startDate: _startDate.toIso8601String(),
        endDate: _endDate.toIso8601String(),
      ),
    );
    context.read<KpiUserCubit>().getUserKpi(
      user.id,
      KpiUserRequest(
        limit: 20,
        offset: 0,
        startDate: _startDate.toIso8601String(),
        endDate: _endDate.toIso8601String(),
      ),
    );
    context.read<WorkloadCubit>().getWorkload(
      WorkloadRequest(startDate: _startDate.toIso8601String(), endDate: _endDate.toIso8601String()),
    );
  }

  Future<void> _pickDateRange() async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: AppColors.primary,
      ),
      dialogSize: const Size(325, 400),
      value: [_startDate, _endDate],
    );

    if (results != null && results.length == 2) {
      setState(() {
        _startDate = results[0]!;
        _endDate = results[1]!;
      });
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = DBService.locale;
    final dateFormat = DateFormat("d MMM", locale);
    final formattedRange = "${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}";

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('kpi'))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 12.h,
          children: [
            SizedBox(height: 24.h),
            ShadowContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      _myKpiText(context),
                      Text(
                        formattedRange,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorText,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: _pickDateRange,
                    child: Text(
                      context.tr('selectDateRange'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                displacement: 50.h,
                strokeWidth: 3,
                onRefresh: () async {
                  _fetchData();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      UserKpiSection(
                        startDate: _startDate.toIso8601String(),
                        endDate: _endDate.toIso8601String(),
                      ),
                      KpiBarChart(),
                      ActualPlanTable(),
                      WorkloadChart(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myKpiText(BuildContext context) {
    return Text(
      context.tr('myKpi'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.sp,
        color: AppColors.colorPrimaryText,
      ),
    );
  }
}
