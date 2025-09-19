import 'dart:developer';

import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/presentation/widgets/custom_dropdown_field.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "New task"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            ShadowContainer(
              child: Column(
                spacing: 6.h,
                children: [
                  /// Clients
                  TaskUpdateField(
                    title: "Select Client",
                    hasDivider: false,
                    hasIcon: false,
                    child: CustomDropdownField<ClientEntity>(
                      hint: "Select Client",
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
                            // clientId = value.id;
                          });
                          log("Selected Client: ${value.name}");
                        }
                      },
                    ),
                  ),

                  /// Clients
                  TaskUpdateField(
                    title: "Select Client",
                    hasDivider: false,
                    hasIcon: false,
                    child: CustomDropdownField<ClientEntity>(
                      hint: "Select Client",
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
                            // clientId = value.id;
                          });
                          log("Selected Client: ${value.name}");
                        }
                      },
                    ),
                  ),

                  // ShadowContainer(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       InkWell(
                  //         onTap: () async {
                  //           final pickedDate = await showDatePicker(
                  //             context: context,
                  //             initialDate: DateTime.now(),
                  //             firstDate: DateTime(1900),
                  //             lastDate: DateTime(2100),
                  //             builder: (context, child) {
                  //               return Theme(
                  //                 data: Theme.of(context).copyWith(
                  //                   colorScheme: ColorScheme.light(
                  //                     primary: AppColors.primary,
                  //                     onPrimary: Colors.white,
                  //                     onSurface: AppColors.black,
                  //                   ),
                  //                 ),
                  //                 child: child!,
                  //               );
                  //             },
                  //           );
                  //
                  //           if (pickedDate != null) {
                  //             // setState(() {
                  //             //   dueAt = pickedDate;
                  //             // });
                  //           }
                  //         },
                  //         child: Text(
                  //           // dueAt != null
                  //           //     ? DateFormat("dd/MM/yyyy").format(dueAt!)
                  //           //     : "DD/MM/YYYY",
                  //           "DD/MM/YYYY",
                  //           style: TextStyle(color: AppColors.black, fontSize: 14.sp),
                  //         ),
                  //       ),
                  //       BasicDivider(marginBottom: 0),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
