import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/presentation/widgets/language_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagesPage extends StatelessWidget {
  static String path = '/language';

  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      appBar: const BasicAppBar(title: 'Language'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            ShadowContainer(
              child: Column(
                children: [
                  LanguageTile(
                    title: "Russian",
                    subtitle: "Русский",
                    locale: const Locale('ru'),
                    selected: currentLocale.languageCode == 'ru',
                    onTap: () {
                      context.setLocale(const Locale('ru'));
                      Navigator.pop(context);
                    },
                  ),
                  const BasicDivider(),
                  LanguageTile(
                    title: "English",
                    subtitle: "English",
                    locale: const Locale('en'),
                    selected: currentLocale.languageCode == 'en',
                    onTap: () {
                      context.setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
