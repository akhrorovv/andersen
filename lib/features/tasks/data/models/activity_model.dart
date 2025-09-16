import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    super.lastStartTime,
    super.lastEndTime,
    required super.runTimeInSeconds,
    required super.userEnteredTimeInSeconds,
    super.description,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int,
      lastStartTime: json['lastStartTime'] != null
          ? DateTime.tryParse(json['lastStartTime'])
          : null,
      lastEndTime: json['lastEndTime'] != null
          ? DateTime.tryParse(json['lastEndTime'])
          : null,
      runTimeInSeconds: json['runTimeInSeconds'] ?? 0,
      userEnteredTimeInSeconds: json['userEnteredTimeInSeconds'] ?? 0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastStartTime': lastStartTime?.toIso8601String(),
      'lastEndTime': lastEndTime?.toIso8601String(),
      'runTimeInSeconds': runTimeInSeconds,
      'description': description,
    };
  }
}
