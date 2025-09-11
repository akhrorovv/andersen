import 'package:flutter/cupertino.dart';

extension CupertinoSheetExtension on BuildContext {
  Future<T?> pushCupertinoSheet<T>(Widget page) {
    return Navigator.of(
      this,
      rootNavigator: true,
    ).push(CupertinoSheetRoute(builder: (_) => page));
  }
}
