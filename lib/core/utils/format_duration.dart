import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';

String formatDurationFromActivities(List<ActivityEntity>? activities) {
  if (activities == null || activities.isEmpty) return "00:00:00";

  final totalSeconds = activities.fold<int>(
    0,
    (sum, activity) => sum + (activity.userEnteredTimeInSeconds),
  );

  final duration = Duration(seconds: totalSeconds);

  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}

String formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final secs = twoDigits(duration.inSeconds.remainder(60));

  return "$hours:$minutes:$secs";
}

String formatKpiDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return "${hours}h${minutes}min";
  } else if (hours > 0) {
    return "${hours}h";
  } else if (minutes > 0) {
    return "${minutes}min";
  } else {
    return "0min";
  }
}

String calculateCompletion(int fact, int plan) {
  if (plan == 0) return "0%";
  final percent = (fact / plan * 100).clamp(0, 100);
  return "${percent.toStringAsFixed(0)}%";
}

