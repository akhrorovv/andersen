import 'package:andersen/core/api/notif_service.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/common/profile/cubit/profile_cubit.dart';
import 'core/config/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // easy localization
  await EasyLocalization.ensureInitialized();
  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  // service locator
  await setupServiceLocator();
  // firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotifService.instance.initialize();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('ru'),
      startLocale: Locale(DBService.locale),
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
          providers: [
            BlocProvider(create: (context) => sl<AuthCubit>()),
            BlocProvider(create: (context) => sl<ProfileCubit>()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
