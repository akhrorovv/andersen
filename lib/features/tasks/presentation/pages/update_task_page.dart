import 'dart:developer';

import 'package:andersen/core/api/interceptors.dart';
import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_type_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/task_types_repository.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_state.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

    LoggerInterceptor.logger.w("matterId: $matterId\ntypeId: $typeId\nDueDate: $dueAt");
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
      body['dueAt'] = '${dueAt?.toIso8601String()}Z';
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                        child: ShadowContainer(
                          child: Column(
                            children: [
                              /// Clients
                              CustomDropdownField<ClientEntity>(
                                title: "Select Client",
                                iconPath: Assets.vectors.briefcase.path,
                                selectedItem: null,
                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (client) {
                                  if (client.type == "COMPANY") return client.name ?? "";
                                  if (client.type == "PERSON") {
                                    final last = client.lastname ?? "";
                                    final first = client.name ?? "";
                                    final middle = client.middlename ?? "";
                                    return "$last $first $middle".trim();
                                  }
                                  return "-";
                                },
                                items: (filter) async {
                                  final result = await sl<ClientsRepository>().getClients(
                                    limit: 10,
                                    offset: 0,
                                    search: (filter != null && filter.length >= 2) ? filter : null,
                                  );
                                  return result.fold((failure) => [], (res) => res.clients);
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      clientId = value.id;
                                    });
                                    log("Selected Client: ${value.name}");
                                  }
                                },
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

                              /// Due Date
                              TaskUpdateField(
                                title: "Due Date",
                                iconPath: Assets.vectors.clock.path,
                                hasDivider: true,
                                child: InkWell(
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: dueAt ?? DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: AppColors.primary,
                                              onPrimary: Colors.white,
                                              onSurface: AppColors.black,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        dueAt = pickedDate;
                                      });
                                    }
                                  },
                                  child: Text(
                                    dueAt != null
                                        ? DateFormat("dd/MM/yyyy").format(dueAt!)
                                        : "DD/MM/YYYY",
                                    style: TextStyle(
                                      color: dueAt != null ? AppColors.black : AppColors.black45,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),

                              /// Task Types
                              CustomDropdownField<TaskTypeEntity>(
                                title: "Task type",
                                iconPath: Assets.vectors.more.path,
                                selectedItem: widget.task.type,
                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (type) => type.name ?? '-',
                                items: (filter) async {
                                  final result = await sl<TaskTypesRepository>().getTypes(
                                    limit: 15,
                                    offset: 0,
                                    search: (filter != null && filter.length >= 2) ? filter : null,
                                  );
                                  return result.fold((failure) => [], (res) => res.types);
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      typeId = value.id;
                                    });
                                    log("Selected Type: ${value.name}");
                                  }
                                },
                              ),

                              /// Matters
                              CustomDropdownField<MatterEntity>(
                                title: "Related Case",
                                hasDivider: false,
                                iconPath: Assets.vectors.briefcase.path,
                                selectedItem: widget.task.matter,
                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (matter) => matter.name,
                                items: (filter) async {
                                  if (clientId == null) return [];
                                  final result = await sl<MattersRepository>().getMatters(
                                    limit: 10,
                                    offset: 0,
                                    clientId: clientId!,
                                    search: (filter != null && filter.length >= 2) ? filter : null,
                                  );
                                  return result.fold((failure) => [], (res) => res.results);
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      matterId = value.id;
                                    });
                                    log("Selected Case: ${value.name}");
                                  }
                                },
                              ),

                              // /// Assigned to
                              // CustomDropdownField<MatterEntity>(
                              //   title: "Assigned to",
                              //   iconPath: Assets.vectors.briefcase.path,
                              //   selectedItem: widget.task.matter,
                              //   compareFn: (a, b) => a.id == b.id,
                              //   itemAsString: (matter) => matter.name,
                              //   items: (filter) async {
                              //     if (clientId == null) return [];
                              //     final result = await sl<MattersRepository>().getMatters(
                              //       limit: 10,
                              //       offset: 0,
                              //       clientId: clientId!,
                              //       search: (filter != null && filter.length >= 2) ? filter : null,
                              //     );
                              //     return result.fold((failure) => [], (res) => res.results);
                              //   },
                              //   onChanged: (value) {
                              //     if (value != null) {
                              //       matterId = value.id;
                              //       log("Selected Person: ${value.name}");
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
