import 'package:intl/intl.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatDueDate(DateTime? dueAt, BuildContext context) {
  if (dueAt == null) return "-";

  final now = DateTime.now();
  final localDueAt = dueAt.toLocal();

  final isToday =
      now.year == localDueAt.year && now.month == localDueAt.month && now.day == localDueAt.day;

  final locale = Localizations.localeOf(context).toString();

  final dayFormat = DateFormat('EEE, MMM d', locale);
  final formattedDate = dayFormat.format(localDueAt);

  if (isToday) {
    return "${Intl.message('Today', name: 'today', locale: locale)}, "
        "${DateFormat('MMM d', locale).format(localDueAt)}";
  } else {
    return formattedDate;
  }
}
