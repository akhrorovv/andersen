import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OptionsPage extends StatefulWidget {
  final EventTarget? initialTarget;

  const OptionsPage({super.key, this.initialTarget});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  EventTarget? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialTarget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('options')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eventsTypeText(context),
            ShadowContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildOption(null, context.tr('all')),
                  _buildOption(EventTarget.firmEvent, EventTarget.firmEvent.label(context)),
                  _buildOption(EventTarget.newClient, EventTarget.newClient.label(context)),
                  _buildOption(EventTarget.caseMeeting, EventTarget.caseMeeting.label(context)),
                ],
              ),
            ),
            Spacer(),
            BasicButton(
              title: context.tr('confirm'),
              onTap: () {
                context.pop(selected);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventsTypeText(BuildContext context) {
    return Text(
      context.tr('eventsType'),
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: AppColors.colorText,
      ),
    );
  }

  Widget _buildOption(EventTarget? value, String label) {
    return RadioListTile<EventTarget?>(
      value: value,
      groupValue: selected,
      activeColor: AppColors.primary,
      onChanged: (val) {
        setState(() {
          selected = val;
        });
      },
      title: Text(label),
    );
  }
}
