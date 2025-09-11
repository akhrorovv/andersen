import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/common/navigation/app_router.dart';
import 'core/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  await setupServiceLocator();
  runApp(const MyApp());
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
            theme: AppTheme.lightTheme,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
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
