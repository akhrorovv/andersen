import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReasonPage extends StatefulWidget {
  static String path = '/reason';

  const ReasonPage({super.key});

  @override
  State<ReasonPage> createState() => _ReasonPageState();
}

class _ReasonPageState extends State<ReasonPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ShadowContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "The reason:",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        maxLines: null,
                        style: TextStyle(
                          color: AppColors.colorPrimaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.shimmer),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.shimmer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BasicButton(
              marginLeft: 0,
              marginRight: 0,
              title: "Send",
              onTap: () {
                if (controller.text.isNotEmpty) {
                  Navigator.pop(context, controller.text);
                } else {
                  BasicSnackBar.show(context, message: "Please enter a reason");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

