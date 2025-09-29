import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:andersen/features/tasks/presentation/cubit/start_activity_cubit.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityStartModalBottomSheet extends StatefulWidget {
  static String path = '/start_activity';
  final TaskEntity? task;

  const ActivityStartModalBottomSheet({super.key, this.task});

  @override
  State<ActivityStartModalBottomSheet> createState() => _ActivityStartModalBottomSheetState();
}

class _ActivityStartModalBottomSheetState extends State<ActivityStartModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  int? taskId;

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityStartCubit>(),
      child: BlocConsumer<ActivityStartCubit, ActivityStartState>(
        listener: (context, state) {
          if (state is ActivityStartSuccess) {
            Navigator.of(context).pop(true);
            BasicSnackBar.show(context, message: 'Activity started successfully');
          } else if (state is ActivityStartFailure) {
            Navigator.of(context).pop(false);
            BasicSnackBar.show(context, message: state.message, error: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(top: 8.h, right: 16.w, left: 16.w, bottom: 16.h),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 30.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          if (widget.task != null)
                            ShadowContainer(
                              child: Column(
                                spacing: 8.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr('task'),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    widget.task!.description ?? '-',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (widget.task == null)
                            /// Select task
                            ShadowContainer(
                              padding: EdgeInsets.only(top: 16.h, right: 16.w, left: 16.w),
                              child: TaskUpdateField(
                                title: context.tr('task'),
                                hasDivider: false,
                                hasIcon: false,
                                child: CustomDropdownField<TaskEntity>(
                                  hint: context.tr('selectTask'),
                                  selectedItem: null,
                                  compareFn: (a, b) => a.id == b.id,
                                  itemAsString: (type) => type.description ?? '-',
                                  items: (filter) async {
                                    final result = await sl<TasksRepository>().getTasks(
                                      limit: 100,
                                      offset: 0,
                                      assignedStaffId: DBService.user!.id,
                                    );
                                    return result.fold((failure) => [], (res) => res.results);
                                  },
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        taskId = value.id;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 12.h),
                          ShadowContainer(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                spacing: 8.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0,
                                      height: 1,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: descriptionController,
                                    maxLines: null,
                                    autofocus: (widget.task != null) ? true : false,
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Description is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: BasicButton(
                      isLoading: state is ActivityStartLoading,
                      title: "Start activity",
                      icon: Assets.vectors.play.path,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final body = {
                            "taskId": (widget.task != null) ? widget.task!.id : taskId,
                            "description": descriptionController.text.trim(),
                          };

                          context.read<ActivityStartCubit>().startActivity(body);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
