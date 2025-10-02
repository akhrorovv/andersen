import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/presentation/pages/change_pin_page.dart';
import 'package:andersen/features/home/presentation/widgets/biometric_setting_tile.dart';
import 'package:andersen/features/home/presentation/widgets/settings_tile.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('security')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          children: [
            ShadowContainer(
              child: Column(
                children: [
                  SettingsTile(
                    iconPath: Assets.vectors.security.path,
                    title: context.tr('changePin'),
                    subtitle: context.tr('pinCode'),
                    onTap: () {
                      // context.pushCupertinoSheet(ChangePinPage());
                      context.push(ChangePinPage.path);
                    },
                  ),
                  BasicDivider(),
                  BiometricSettingTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
