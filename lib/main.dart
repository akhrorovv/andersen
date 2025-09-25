import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/common/navigation/app_router.dart';
import 'core/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // easy localization
  await EasyLocalization.ensureInitialized();
  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  // service locator
  await setupServiceLocator();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('ru'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => sl<AuthCubit>())],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,

            /// Locale
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            /// Theme
            theme: AppTheme.lightTheme,

            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                child: widget!,
              );
            },
            routerConfig: router,
          ),
        );
      },
    );
  }
}
