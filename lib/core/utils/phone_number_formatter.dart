import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneMaskFormatter = MaskTextInputFormatter(
  mask: '+998 ## ### ## ##',
  filter: {"#": RegExp(r'[0-9]')},
);

String formatPhoneNumber(String phone) {
  phone = phone.substring(3);
  return phoneMaskFormatter.maskText(phone);
}
