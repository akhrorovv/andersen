import 'package:intl/intl.dart';

String formatDueDate(DateTime? dueAt) {
  if (dueAt == null) return "-";

  final now = DateTime.now();
  final localDueAt = dueAt.toLocal();

  final isToday =
      now.year == localDueAt.year &&
      now.month == localDueAt.month &&
      now.day == localDueAt.day;

  final dayFormat = DateFormat('EEE, MMM d');
  final formattedDate = dayFormat.format(dueAt.toLocal());

  if (isToday) {
    return "Today, ${DateFormat('MMM d').format(dueAt.toLocal())}";
  } else {
    return formattedDate;
  }
}
