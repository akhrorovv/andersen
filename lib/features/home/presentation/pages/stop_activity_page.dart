import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activity_type_entity.dart';
import 'package:andersen/features/home/domain/repositories/activity_types_repository.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/cubit/stop_activity_cubit.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class StopActivityPage extends StatefulWidget {
  static String path = '/stop_activity';
  final int activityId;

  const StopActivityPage({super.key, required this.activityId});

  @override
  State<StopActivityPage> createState() => _StopActivityPageState();
}

class _StopActivityPageState extends State<StopActivityPage> {
  final descriptionController = TextEditingController();
  int userEnteredTime = 0;
  int? typeId;

  void _onStop(int activityId) {
    final Map<String, dynamic> body = {};

    if (descriptionController.text.trim().isNotEmpty) {
      body["description"] = descriptionController.text.trim();
    }

    if (userEnteredTime != 0) {
      body["userEnteredTimeInSeconds"] = userEnteredTime;
    }

    if (typeId != null) {
      body["typeId"] = typeId;
    }

    if (body.isNotEmpty) {
      // sl<StopActivityCubit>().stopActivity(activityId, body);
      context.read<StopActivityCubit>().stopActivity(activityId, body);

    } else {
      context.pop(false);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _showTimerPicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.h,
            children: [
              Text(
                "Entered time",
                style: TextStyle(
                  color: AppColors.colorText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: Duration.zero,
                minuteInterval: 1,
                secondInterval: 1,
                onTimerDurationChanged: (duration) {
                  setState(() {
                    userEnteredTime = duration.inSeconds;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: 'Time entry'),
      body: BlocConsumer<StopActivityCubit, StopActivityState>(
        listener: (context, state) {
          if (state is StopActivitySuccess) {
            // context.pop(true);
            Navigator.of(context, rootNavigator: true).pop(true);
            BasicSnackBar.show(context, message: 'Activity stopped successfully');
          } else if (state is StopActivityError) {
            // context.pop(false);
            Future.microtask(() {
              Navigator.of(context, rootNavigator: true).pop(false);
            });
            BasicSnackBar.show(context, message: state.message, error: true);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12.h,
                      children: [
                        /// total run time
                        ShadowContainer(
                          child: BlocBuilder<ActivityStatusCubit, ActivityStatusState>(
                            builder: (context, state) {
                              if (state is ActivityStatusLoading) {
                                return LoadingIndicator();
                              } else if (state is ActivityStatusActive) {
                                return Column(
                                  spacing: 4.h,
                                  children: [
                                    Text(
                                      "Total time",
                                      style: TextStyle(
                                        color: AppColors.colorText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      formatDuration(state.elapsedSeconds),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),

                        /// entered time
                        ShadowContainer(
                          child: Column(
                            spacing: 4.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User entered time",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                  letterSpacing: 0,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showTimerPicker(context);
                                },
                                child: Text(
                                  formatDuration(userEnteredTime),
                                  style: TextStyle(
                                    color: AppColors.colorText,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Description
                        ShadowContainer(
                          child: Column(
                            spacing: 4.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                  letterSpacing: 0,
                                ),
                              ),
                              TextFormField(
                                controller: descriptionController,
                                maxLines: null,
                                style: TextStyle(
                                  color: AppColors.colorText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: "Enter description",
                                  hintStyle: TextStyle(
                                    color: AppColors.colorBgMask,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Activity type
                        ShadowContainer(
                          padding: EdgeInsets.only(top: 16.h, right: 16.w, left: 16.w),
                          child: TaskUpdateField(
                            title: "Type",
                            hasDivider: false,
                            hasIcon: false,
                            child: CustomDropdownField<ActivityTypeEntity>(
                              hint: "Select activity type",
                              selectedItem: null,
                              compareFn: (a, b) => a.id == b.id,
                              itemAsString: (type) => type.name ?? '-',
                              items: (filter) async {
                                final result = await sl<ActivityTypesRepository>().getTypes(
                                  limit: 50,
                                  offset: 0,
                                );
                                return result.fold((failure) => [], (res) => res.types);
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    typeId = value.id;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                BasicButton(
                  marginLeft: 0,
                  marginRight: 0,
                  title: 'Save',
                  onTap: () {
                    _onStop(widget.activityId);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
