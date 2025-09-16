import 'package:andersen/core/api/interceptors.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/presentation/cubit/matter_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/matter_state.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_cubit.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UpdateTaskPage extends StatefulWidget {
  final TaskEntity task;

  const UpdateTaskPage({super.key, required this.task});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  late TextEditingController descriptionController;
  DateTime? dueAt;
  int? typeId;
  int? matterId;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    dueAt = widget.task.dueAt;
    typeId = widget.task.type?.id;
    matterId = widget.task.matter?.id;

    LoggerInterceptor.logger.w("matterId: $matterId\ntypeId: $typeId");
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
    final Map<String, dynamic> body = {};

    if (descriptionController.text != widget.task.description) {
      body['description'] = descriptionController.text.trim();
    }
    if (dueAt != widget.task.dueAt) {
      body['dueAt'] = dueAt?.toIso8601String();
    }
    if (typeId != widget.task.type?.id) {
      body['typeId'] = typeId;
    }
    if (matterId != widget.task.matter?.id) {
      body['matterId'] = matterId;
    }

    if (body.isNotEmpty) {
      context.read<TaskUpdateCubit>().updateTask(widget.task.id, body);
      context.pop(true);
    } else {
      context.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Edit task"),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  child: ShadowContainer(
                    child: Column(
                      children: [
                        /// Description
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.w,
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundColor: AppColors.primary,
                              child: SvgPicture.asset(
                                Assets.vectors.textAlignLeft.path,
                                width: 16.w,
                                height: 16.w,
                                colorFilter: ColorFilter.mode(
                                  AppColors.colorTextWhite,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4.h,
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
                                  TextField(
                                    controller: descriptionController,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: AppColors.colorText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      hintText: "No description entered",
                                      hintStyle: TextStyle(
                                        color: AppColors.colorBgMask,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  BasicDivider(marginTop: 0),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Related case
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.w,
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundColor: AppColors.primary,
                              child: SvgPicture.asset(
                                Assets.vectors.briefcase.path,
                                width: 16.w,
                                height: 16.w,
                                colorFilter: ColorFilter.mode(
                                  AppColors.colorTextWhite,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // spacing: 4.h,
                                children: [
                                  // Text(
                                  //   "Related case",
                                  //   style: TextStyle(
                                  //     color: AppColors.grey,
                                  //     fontSize: 12.sp,
                                  //     fontWeight: FontWeight.w400,
                                  //     height: 1.2,
                                  //     letterSpacing: 0,
                                  //   ),
                                  // ),
                                  BlocProvider(
                                    create: (_) =>
                                        sl<MatterCubit>()..getMatters(),
                                    child: BlocBuilder<MatterCubit, MatterState>(
                                      builder: (context, state) {
                                        if (state is MatterLoading) {
                                          return const CircularProgressIndicator();
                                        } else if (state is MatterLoaded) {
                                          return DropdownSearch<MatterEntity>(
                                            items: (f, cs) =>
                                                state.matters.results,
                                            itemAsString: (MatterEntity m) =>
                                                m.name ?? "",
                                            compareFn:
                                                (
                                                  MatterEntity a,
                                                  MatterEntity b,
                                                ) => a.id == b.id,
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              menuProps: MenuProps(
                                                backgroundColor:
                                                    AppColors.background,
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                  hintText: "Search...",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            decoratorProps:
                                                DropDownDecoratorProps(
                                                  decoration: InputDecoration(
                                                    label: Text("Related case"),
                                                    labelStyle: TextStyle(
                                                      color: AppColors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15.sp,
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .shimmer,
                                                              ),
                                                        ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .shimmer,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                            onChanged: (matter) {
                                              setState(() {
                                                matterId = matter?.id;
                                              });
                                            },
                                          );
                                        } else if (state is MatterError) {
                                          return Text(
                                            "Error: ${state.message}",
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  BasicDivider(marginTop: 0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            bottom: true,
            child: BasicButton(marginBottom: 32, title: "Save", onTap: _onSave),
          ),
        ],
      ),
    );
  }
}
