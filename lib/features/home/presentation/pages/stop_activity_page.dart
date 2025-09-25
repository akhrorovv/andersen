import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activity_type_entity.dart';
import 'package:andersen/features/home/domain/repositories/activity_types_repository.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StopActivityPage extends StatelessWidget {
  static String path = '/stop_activity';

  const StopActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: 'Time entry'),
      body: Padding(
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
                          if (state is ActivityStatusActive) {
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
                          TextFormField(
                            // controller: descriptionController,
                            maxLines: null,
                            style: TextStyle(
                              color: AppColors.colorText,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              hintText: "00:00:00",
                              hintStyle: TextStyle(
                                color: AppColors.colorBgMask,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return "Description is required";
                            //   }
                            //   return null;
                            // },
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
                            // controller: descriptionController,
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
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return "Description is required";
                            //   }
                            //   return null;
                            // },
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
                            // if (value != null) {
                            //   setState(() {
                            //     typeId = value.id;
                            //   });
                            //   log("Selected Type: ${value.name}");
                            // }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BasicButton(marginLeft: 0, marginRight: 0, title: 'Save', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
