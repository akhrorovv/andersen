import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
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
  String? selected;

  @override
  void initState() {
    super.initState();
    if (widget.initialTarget != null) {
      selected = widget.initialTarget!.apiValue;
    } else {
      selected = "ALL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: 'Options'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eventsTypeText(),
            ShadowContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildOption("ALL", "All"),
                  _buildOption("FIRM_EVENT", "Company Event"),
                  _buildOption("NEW_CLIENT", "New Client"),
                  _buildOption("CASE_MEETING", "Case Meeting"),
                ],
              ),
            ),

            Spacer(),
            BasicButton(
              marginRight: 0,
              marginLeft: 0,
              title: 'Confirm',
              onTap: () {
                if (selected == "ALL") {
                  context.pop(null);
                } else {
                  context.pop(selected);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventsTypeText() {
    return Text(
      "Events type",
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: AppColors.colorText,
      ),
    );
  }

  Widget _buildOption(String value, String label) {
    return RadioListTile<String>(
      value: value,
      groupValue: selected,
      onChanged: (val) {
        setState(() {
          selected = val;
        });
      },
      title: Text(label),
    );
  }
}
