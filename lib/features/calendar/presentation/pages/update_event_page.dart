import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/update_event_cubit.dart';
import 'package:andersen/features/calendar/presentation/widgets/event_update_field.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateEventPage extends StatefulWidget {
  final EventEntity event;

  const UpdateEventPage({super.key, required this.event});

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  EventTarget? target;
  int? clientId;
  int? matterId;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.event.description);
    locationController = TextEditingController(text: widget.event.location);
    target = EventTargetX.fromString(widget.event.target);
    clientId = widget.event.matter?.contract?.clientId;
    matterId = widget.event.matter?.id;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _onSave() {
    final Map<String, dynamic> body = {};

    if (descriptionController.text != widget.event.description) {
      body['description'] = descriptionController.text.trim();
    }
    if (locationController.text != widget.event.location) {
      body['location'] = locationController.text.trim();
    }

    if (target == EventTarget.caseMeeting) {
    body['matterId'] = matterId;
    }
    if (target != EventTargetX.fromString(widget.event.target)) {
      body['target'] = target?.apiValue;
    }

    if (body.isNotEmpty) {
      context.read<UpdateEventCubit>().updateEvent(widget.event.id, body);
    } else {
      context.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Edit event"),
      body: BlocConsumer<UpdateEventCubit, UpdateEventState>(
        listener: (context, state) {
          if (state is UpdateEventSuccess) {
            context.pop(true);
            BasicSnackBar.show(context, message: 'Event updated successfully');
          } else if (state is UpdateEventError) {
            context.pop(false);
            BasicSnackBar.show(context, message: state.message, error: true);
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
                              /// Description
                              EventUpdateField(
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

                              /// Location
                              EventUpdateField(
                                title: "Location",
                                iconPath: Assets.vectors.location.path,
                                hasDivider: true,
                                child: TextField(
                                  controller: locationController,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: AppColors.colorText,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    hintText: "No location entered",
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

                              /// Event Target
                              EventUpdateField(
                                title: "Event type",
                                hasDivider: false,
                                iconPath: Assets.vectors.calendarFav.path,
                                child: CustomDropdownField<EventTarget>(
                                  hint: "Select Event Type",
                                  selectedItem: target,
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
                                EventUpdateField(
                                  title: "Select Client",
                                  iconPath: Assets.vectors.briefcase.path,
                                  hasDivider: false,
                                  child: CustomDropdownField<ClientEntity>(
                                    hint: "Select Client",
                                    // selectedItem: clientId,
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

                              /// Matters
                              if (target == EventTarget.caseMeeting)
                                EventUpdateField(
                                  title: "Related Case",
                                  hasDivider: false,
                                  iconPath: Assets.vectors.briefcase.path,
                                  child: CustomDropdownField<MatterEntity>(
                                    hint: "Related Case",
                                    selectedItem: widget.event.matter,
                                    compareFn: (a, b) => a.id == b.id,
                                    itemAsString: (matter) => matter.name,
                                    items: (filter) async {
                                      if (clientId == null) return [];
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
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          matterId = value.id;
                                        });
                                      }
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
              BasicButton(title: "Save", onTap: _onSave),
            ],
          );
        },
      ),
    );
  }
}
