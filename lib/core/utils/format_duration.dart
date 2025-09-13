import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';

String formatDurationFromActivities(List<ActivityEntity>? activities) {
  if (activities == null || activities.isEmpty) return "00:00:00";

  final totalSeconds = activities.fold<int>(
    0,
    (sum, activity) => sum + (activity.userEnteredTimeInSeconds ?? 0),
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
