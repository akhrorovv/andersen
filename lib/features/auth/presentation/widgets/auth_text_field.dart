import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/phone_number_formatter.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AuthField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.label}:",
          style: TextStyle(
            color: AppColors.colorText,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            color: AppColors.colorPrimaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.shimmer),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: _toggleObscure,
                    icon: _isObscured
                        ? SvgPicture.asset(Assets.vectors.show.path)
                        : SvgPicture.asset(Assets.vectors.hide.path),
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${widget.label} is required";
            }
            if (widget.obscureText) {
              // Password validation
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
            } else {
              String digitsOnly = phoneMaskFormatter.getUnmaskedText();
              if (digitsOnly.length != 9) {
                return "Enter a valid phone number !";
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
