import 'dart:developer';

import 'package:andersen/core/api/interceptors.dart';
import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_state.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateTaskPage extends StatefulWidget {
  final TaskEntity task;

  const UpdateTaskPage({super.key, required this.task});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  late TextEditingController descriptionController;
  final searchController = TextEditingController();
  DateTime? dueAt;
  int? typeId;
  int? clientId;
  int? matterId;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.task.description);
    dueAt = widget.task.dueAt;
    typeId = widget.task.type?.id;
    matterId = widget.task.matter?.contract?.clientId;
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
    } else {
      context.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Edit task"),
      body: BlocConsumer<TaskUpdateCubit, TaskUpdateState>(
        listener: (context, state) {
          if (state is TaskUpdateSuccess) {
            context.pop(true);
          } else if (state is TaskUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: ShadowContainer(
                        child: Column(
                          children: [
                            /// Clients
                            TaskUpdateField(
                              title: "Select Client",
                              iconPath: Assets.vectors.briefcase.path,
                              child: DropdownSearch<ClientEntity>(
                                items: (String? filter, props) async {
                                  final result = await sl<ClientsRepository>().getClients(
                                    limit: 10,
                                    offset: 0,
                                    search: (filter != null && filter.length >= 2) ? filter : null,
                                  );

                                  return result.fold((failure) => [], (result) => result.clients);
                                },

                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (ClientEntity client) {
                                  if (client.type == "COMPANY") {
                                    return client.name ?? "";
                                  } else if (client.type == "PERSON") {
                                    final last = client.lastname ?? "";
                                    final first = client.name ?? "";
                                    final middle = client.middlename ?? "";
                                    return "$last $first $middle".trim();
                                  }
                                  return "-";
                                },
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 0,
                                    ),
                                    hintText: "Select Client",
                                    hintStyle: TextStyle(color: AppColors.black45),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(color: AppColors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),

                                popupProps: PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSearchBox: true,
                                  showSelectedItems: true,
                                  menuProps: MenuProps(
                                    backgroundColor: AppColors.background,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "Search...",
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primary),
                                      ),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  clientId = value!.id;
                                  log("Selected Client: ${value.name}");
                                },
                              ),
                            ),

                            /// Matters
                            TaskUpdateField(
                              title: "Related Case",
                              iconPath: Assets.vectors.briefcase.path,
                              child: DropdownSearch<MatterEntity>(
                                items: (String? filter, props) async {
                                  if (clientId != null) {
                                    final result = await sl<MattersRepository>().getMatters(
                                      limit: 10,
                                      offset: 0,
                                      clientId: clientId!,
                                      search: (filter != null && filter.length >= 2)
                                          ? filter
                                          : null,
                                    );

                                    return result.fold((failure) => [], (result) => result.results);
                                  }
                                  return [];
                                },

                                selectedItem: widget.task.matter,

                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (MatterEntity matter) => matter.name,

                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 0,
                                    ),
                                    hintText: "Select Case",
                                    hintStyle: TextStyle(color: AppColors.black45),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(color: AppColors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),

                                popupProps: PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSearchBox: true,
                                  showSelectedItems: true,
                                  menuProps: MenuProps(
                                    backgroundColor: AppColors.background,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "Search...",
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primary),
                                      ),
                                    ),
                                  ),
                                ),

                                onChanged: (value) {
                                  matterId = value!.id;
                                  log("Selected Case: ${value.name}");
                                },
                              ),
                            ),

                            /// Description
                            TaskUpdateField(
                              title: "Description",
                              iconPath: Assets.vectors.textAlignLeft.path,
                              hasDivider: true,
                              child: TextField(
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
          );
        },
      ),
    );
  }
}
