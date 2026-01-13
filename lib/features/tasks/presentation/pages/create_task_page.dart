import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_type_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/task_types_repository.dart';
import 'package:andersen/features/tasks/presentation/cubit/create_task_cubit.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  int? clientId;
  int? matterId;
  DateTime? dueAt;
  final descriptionController = TextEditingController();
  int? typeId;

  void _onCreate() {
    final Map<String, dynamic> body = {
      "description": descriptionController.text.trim(),
      "matterId": matterId!,
    };

    if (dueAt != null) {
      body["dueAt"] = '${dueAt!.toIso8601String()}Z';
    }

    if (typeId != null) {
      body["typeId"] = typeId;
    }

    body["assignedStaffId"] = DBService.user!.id;

    if (body.isNotEmpty) {
      context.read<CreateTaskCubit>().createTask(body);
    } else {
      context.pop(false);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('newTask')),
      body: BlocConsumer<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateTaskSuccess) {
            context.pop(true);
          } else if (state is CreateTaskError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ShadowContainer(
                            child: Column(
                              spacing: 6.h,
                              children: [
                                /// Clients
                                TaskUpdateField(
                                  title: context.tr('selectClient'),
                                  hasDivider: false,
                                  hasIcon: false,
                                  child: CustomDropdownField<ClientEntity>(
                                    hint: context.tr('selectClient'),
                                    selectedItem: null,
                                    compareFn: (a, b) => a.id == b.id,
                                    itemAsString: (client) {
                                      if (client.type == "COMPANY")
                                        return client.name ?? "";
                                      if (client.type == "PERSON") {
                                        final last = client.lastname ?? "";
                                        final first = client.name ?? "";
                                        final middle = client.middlename ?? "";
                                        return "$last $first $middle".trim();
                                      }
                                      return "-";
                                    },
                                    items: (filter) async {
                                      final result = await sl<ClientsRepository>()
                                          .getClients(
                                            limit: 50,
                                            offset: 0,
                                            search:
                                                (filter != null &&
                                                    filter.length >= 2)
                                                ? filter
                                                : null,
                                          );
                                      return result.fold(
                                        (failure) => [],
                                        (res) => res.clients,
                                      );
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          clientId = value.id;
                                        });
                                      }
                                    },
                                  ),
                                ),

                                /// Case
                                TaskUpdateField(
                                  title: context.tr('case'),
                                  hasDivider: false,
                                  hasIcon: false,
                                  child: CustomDropdownField<MatterEntity>(
                                    hint: context.tr('selectCase'),
                                    selectedItem: null,
                                    compareFn: (a, b) => a.id == b.id,
                                    itemAsString: (m) => m.name,
                                    items: (String? filter) async {
                                      if (clientId == null) return <MatterEntity>[];
                                      final result = await sl<MattersRepository>()
                                          .getMatters(
                                            limit: 50,
                                            offset: 0,
                                            clientId: clientId!,
                                            taskCreatable: true,
                                            search:
                                                (filter != null &&
                                                    filter.length >= 2)
                                                ? filter
                                                : null,
                                          );
                                      return result.fold(
                                        (failure) => [],
                                        (res) => res.results,
                                      );
                                    },
                                    onChanged: (m) {
                                      if (m != null) setState(() => matterId = m.id);
                                    },
                                  ),
                                ),

                                /// Due Date
                                TaskUpdateField(
                                  title: context.tr('dueDate'),
                                  hasDivider: true,
                                  hasIcon: false,
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
                                        color: dueAt != null
                                            ? AppColors.black
                                            : AppColors.black45,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Description
                                TaskUpdateField(
                                  title: context.tr('description'),
                                  hasDivider: true,
                                  hasIcon: false,
                                  child: TextFormField(
                                    controller: descriptionController,
                                    maxLines: null,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return context.tr('descriptionRequired');
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      color: AppColors.colorText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      hintText: context.tr('enterDescription'),
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

                                /// Task type
                                TaskUpdateField(
                                  title: context.tr('taskType'),
                                  hasDivider: false,
                                  hasIcon: false,
                                  child: CustomDropdownField<TaskTypeEntity>(
                                    hint: context.tr('selectTaskType'),
                                    selectedItem: null,
                                    compareFn: (a, b) => a.id == b.id,
                                    itemAsString: (type) => type.name ?? '-',
                                    items: (filter) async {
                                      final result = await sl<TaskTypesRepository>()
                                          .getTypes(limit: 50, offset: 0);
                                      return result.fold(
                                        (failure) => [],
                                        (res) => res.types,
                                      );
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: BasicButton(
                      title: context.tr('create'),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (matterId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('caseMustBeSelected')),
                              ),
                            );
                            return;
                          }
                          _onCreate();
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
