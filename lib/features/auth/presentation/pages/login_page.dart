import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/common/entities/device_entity.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/device_info_helper.dart';
import 'package:andersen/core/utils/phone_number_formatter.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:andersen/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:andersen/gen/assets.gen.dart';
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
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            BasicSnackBar.show(context, message: state.message, error: true);
          } else if (state is AuthSuccess) {
            BasicSnackBar.show(context, message: context.tr('successLogin'));
            context.go(CheckingPage.path);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
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
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return BasicButton(
                        title: context.tr('logIn'),
                        isLoading: state is AuthLoading,
                        onTap: () async {
                          final cubit = context.read<AuthCubit>();
                          if (_formKey.currentState!.validate()) {
                            final phone = formatPhone(_phoneController.text.trim());
                            final password = _passwordController.text.trim();

                            final results = await Future.wait([
                              DeviceInfoHelper.model,
                              DeviceInfoHelper.version,
                            ]);
                            final model = results[0];
                            final version = results[1];
                            final locale = DeviceInfoHelper.locale;

                            // save
                            await Future.wait([
                              DBService.saveDeviceModel(model),
                              DBService.saveDeviceVersion(version),
                            ]);

                            final token = DBService.fcmToken ?? '';

                            final params = LoginParams(
                              phone: phone,
                              password: password,
                              device: DeviceEntity(
                                model: model,
                                version: version,
                                locale: locale,
                                fcmToken: token.isEmpty ? 'null' : token,
                              ),
                            );
                            cubit.login(params);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
