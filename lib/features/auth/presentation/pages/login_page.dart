import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/entities/device_entity.dart';
import 'package:andersen/core/utils/device_info_helper.dart';
import 'package:andersen/core/utils/phone_number_formatter.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static String path = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController(text: "+998");
  final TextEditingController _passwordController = TextEditingController();

  String formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              BasicSnackBar.show(context, message: state.message, error: true);
            } else if (state is AuthSuccess) {
              BasicSnackBar.show(context, message: context.tr('successLogin'));
              context.go(HomePage.path);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _welcomeText(),
                      SizedBox(height: 32.h),
                      SizedBox(width: 150.w, child: Assets.images.login.image()),
                      SizedBox(height: 32.h),
                      AuthField(
                        label: context.tr('phone'),
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [phoneMaskFormatter],
                      ),
                      SizedBox(height: 16.h),
                      AuthField(
                        label: context.tr('password'),
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final cubit = context.read<AuthCubit>();
                          if (_formKey.currentState!.validate()) {
                            final phone = formatPhone(_phoneController.text.trim());
                            final password = _passwordController.text.trim();

                            final model = await DeviceInfoHelper.model;
                            final version = await DeviceInfoHelper.version;
                            final locale = DeviceInfoHelper.locale;

                            final params = LoginParams(
                              phone: phone,
                              password: password,
                              device: DeviceEntity(
                                model: model,
                                version: version,
                                locale: locale,
                                fcmToken: "fake_token",
                              ),
                            );
                            cubit.login(params);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(MediaQuery.of(context).size.width.w, 48.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                        child: Text(
                          context.tr('logIn'),
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _welcomeText() {
    return Row(
      children: [
        Text(
          context.tr('welcome'),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
            color: AppColors.colorPrimaryText,
          ),
        ),
      ],
    );
  }
}
