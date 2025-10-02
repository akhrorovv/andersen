import 'dart:developer';

import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/repositories/users_repository.dart';
import 'package:andersen/features/calendar/presentation/cubit/create_event_cubit.dart';
import 'package:andersen/features/calendar/presentation/widgets/custom_multi_dropdown_field.dart';
import 'package:andersen/features/calendar/presentation/widgets/event_field.dart';
import 'package:andersen/core/common/entities/user_entity.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? startAt;
  DateTime? endAt;
  EventTarget? target = EventTarget.firmEvent;
  int? clientId;
  int? matterId;

  List<UserEntity> selectedUsers = [];

  void _onCreate() {
    final Map<String, dynamic> body = {"description": descriptionController.text.trim()};

    if (startAt != null) {
      body["startsAt"] = '${startAt!.toIso8601String()}Z';
    }

    if (endAt != null) {
      body["endsAt"] = '${endAt!.toIso8601String()}Z';
    }

    if (target != null) {
      body["target"] = target?.apiValue;
    }

    if (locationController.text.trim().isNotEmpty) {
      body["location"] = locationController.text.trim();
    }

    if (matterId != null) {
      body["matterId"] = matterId;
    }

    if (selectedUsers.isNotEmpty) {
      body["attendees"] = selectedUsers.map((u) => u.id).toList();
    }

    if (body.isNotEmpty) {
      context.read<CreateEventCubit>().createEvent(body);
    } else {
      context.pop(false);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('newEvent')),
      body: BlocConsumer<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventSuccess) {
            context.pop(true);
          } else if (state is CreateEventError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ShadowContainer(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              spacing: 6.h,
                              children: [
                                /// Description
                                EventField(
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

                                /// Location
                                EventField(
                                  title: context.tr('location'),
                                  hasDivider: true,
                                  hasIcon: false,
                                  child: TextFormField(
                                    controller: locationController,
                                    maxLines: null,
                                    // validator: (value) {
                                    //   if (value == null || value.trim().isEmpty) {
                                    //     return "Location should not be empty";
                                    //   }
                                    //   return null;
                                    // },
                                    style: TextStyle(
                                      color: AppColors.colorText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      hintText: context.tr('enterLocation'),
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

                                /// Starts At
                                EventField(
                                  title: context.tr('startsAt'),
                                  hasDivider: true,
                                  hasIcon: false,
                                  child: InkWell(
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
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
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          setState(() {
                                            startAt = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              pickedTime.hour,
                                              pickedTime.minute,
                                            );
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      startAt != null
                                          ? DateFormat("dd/MM/yyyy HH:mm").format(startAt!)
                                          : "DD/MM/YYYY HH:MM",
                                      style: TextStyle(
                                        color: startAt != null
                                            ? AppColors.black
                                            : AppColors.black45,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Ends At
                                EventField(
                                  title: context.tr('endsAt'),
                                  hasDivider: true,
                                  hasIcon: false,
                                  child: InkWell(
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
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
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          setState(() {
                                            endAt = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              pickedTime.hour,
                                              pickedTime.minute,
                                            );
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      endAt != null
                                          ? DateFormat("dd/MM/yyyy HH:mm").format(endAt!)
                                          : "DD/MM/YYYY HH:MM",
                                      style: TextStyle(
                                        color: endAt != null ? AppColors.black : AppColors.black45,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Event Type
                                EventField(
                                  title: context.tr('selectEventType'),
                                  hasDivider: false,
                                  hasIcon: false,
                                  child: CustomDropdownField<EventTarget>(
                                    hint: context.tr('selectEventType'),
                                    selectedItem: EventTarget.firmEvent,
                                    compareFn: (a, b) => a == b,
                                    itemAsString: (eventTarget) => eventTarget.label,
                                    items: (filter) async {
                                      return EventTarget.values;
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          target = value;
                                        });
                                      }
                                    },
                                  ),
                                ),

                                /// Clients
                                if (target == EventTarget.caseMeeting)
                                  EventField(
                                    title: context.tr('selectClient'),
                                    hasDivider: false,
                                    hasIcon: false,
                                    child: CustomDropdownField<ClientEntity>(
                                      hint: context.tr('selectClient'),
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
                                          search: (filter != null && filter.length >= 2)
                                              ? filter
                                              : null,
                                        );
                                        return result.fold((failure) => [], (res) => res.clients);
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
                                if (target == EventTarget.caseMeeting)
                                  EventField(
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
                                        final result = await sl<MattersRepository>().getMatters(
                                          limit: 10,
                                          offset: 0,
                                          clientId: clientId!,
                                          taskCreatable: true,
                                          search: (filter != null && filter.length >= 2)
                                              ? filter
                                              : null,
                                        );
                                        return result.fold((failure) => [], (res) => res.results);
                                      },
                                      onChanged: (m) {
                                        if (m != null) setState(() => matterId = m.id);
                                      },
                                    ),
                                  ),

                                /// Users
                                EventField(
                                  title: context.tr('selectAttendees'),
                                  hasDivider: false,
                                  hasIcon: false,
                                  child: CustomMultiDropdownField<UserEntity>(
                                    hint: context.tr('selectUsers'),
                                    items: (filter) async {
                                      final result = await sl<UsersRepository>().getUsers(
                                        limit: 10,
                                        offset: 0,
                                        search: (filter != null && filter.length >= 2)
                                            ? filter
                                            : null,
                                        status: 'ACTIVE',
                                      );
                                      return result.fold((failure) => [], (res) => res.users);
                                    },
                                    itemAsString: (user) => user.name,
                                    compareFn: (a, b) => a.id == b.id,
                                    selectedItems: selectedUsers,
                                    onChanged: (values) {
                                      setState(() {
                                        selectedUsers = values;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 32.h, right: 16.w, left: 16.w),
                  child: BasicButton(
                    title: context.tr('create'),
                    isLoading: state is CreateEventLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (startAt == null || endAt == null) {
                          BasicSnackBar.show(
                            context,
                            message: context.tr('startsAtAndEndsAtMustBeSelected'),
                            error: true,
                          );
                          return;
                        }

                        if (target == null) {
                          BasicSnackBar.show(
                            context,
                            message: context.tr('targetMustBeSelected'),
                            error: true,
                          );
                          return;
                        }

                        if (target == EventTarget.caseMeeting && matterId == null) {
                          BasicSnackBar.show(
                            context,
                            message: context.tr('caseMustBeSelectedForCaseMeeting'),
                            error: true,
                          );
                          return;
                        }

                        _onCreate();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
