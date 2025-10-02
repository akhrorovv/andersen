import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/home/presentation/widgets/settings_tile.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class BiometricSettingTile extends StatefulWidget {
  const BiometricSettingTile({super.key});

  @override
  State<BiometricSettingTile> createState() => _BiometricSettingTileTileState();
}

class _BiometricSettingTileTileState extends State<BiometricSettingTile> {
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final enabled = DBService.biometricEnabled;
    setState(() => _enabled = enabled);
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() => _enabled = value);
    await DBService.saveBiometricStatus(value);

    if (value) {
      // Biometrics enabled
      debugPrint("✅ Biometric login enabled");
    } else {
      // Biometrics disabled → fallback to PIN
      debugPrint("❌ Biometric login disabled, PIN required");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      iconPath: Assets.vectors.fingerPrint.path,
      title: context.tr('loginUsingBiometrics'),
      subtitle: context.tr('faceIdOrTouchId'),
      trailing: CupertinoSwitch(
        activeTrackColor: AppColors.primary,
        value: _enabled,
        onChanged: _toggleBiometric,
      ),
    );
  }
}
