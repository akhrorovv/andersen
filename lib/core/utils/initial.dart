import 'package:flutter/material.dart';

String getInitials(String? name) {
  if (name == null || name.trim().isEmpty) {
    return "";
  }

  // so‘zlarni bo‘lish
  final parts = name.trim().split(RegExp(r"\s+"));

  if (parts.length == 1) {
    // faqat bitta ism bo‘lsa
    return parts.first.characters.first.toUpperCase();
  } else {
    // ikki yoki undan ortiq bo‘lsa
    final first = parts[0].characters.first.toUpperCase();
    final second = parts[1].characters.first.toUpperCase();
    return "$first$second";
  }
}