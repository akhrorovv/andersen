import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/home/presentation/widgets/settings_tile.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationSettingsTile extends StatefulWidget {
  const NotificationSettingsTile({super.key});

  @override
  State<NotificationSettingsTile> createState() => _NotificationSettingsTileState();
}

class _NotificationSettingsTileState extends State<NotificationSettingsTile> {
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final enabled = DBService.notifEnabled;
    setState(() => _enabled = enabled);
  }

  Future<void> _toggleNotif(bool value) async {
    setState(() => _enabled = value);
    await DBService.saveNotifStatus(value);

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("all_users");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      iconPath: Assets.vectors.notification.path,
      title: context.tr('notifications'),
      subtitle: _enabled ? context.tr('switchToDisable') : context.tr('switchToEnable'),
      trailing: CupertinoSwitch(
        activeTrackColor: AppColors.primary,
        value: _enabled,
        onChanged: _toggleNotif,
      ),
    );
  }
}

