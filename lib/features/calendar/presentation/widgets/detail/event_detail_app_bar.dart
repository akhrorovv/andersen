import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/delete_event_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EventDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final EventEntity event;

  const EventDetailAppBar({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: AppColors.white),
      actions: [
        IconButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) {
                return CupertinoActionSheet(
                  title: Text(
                    "Calendar event option",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        if (event.createdById == DBService.user!.id) {
                          context.read<DeleteEventCubit>().deleteEvent(event.id);
                          context.pop();
                        } else {
                          context.pop();
                          BasicSnackBar.show(context, message: "This is not your event!");
                        }
                      },

                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.more_vert, color: AppColors.white, size: 22),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
