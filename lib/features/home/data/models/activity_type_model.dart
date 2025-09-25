import 'package:andersen/features/activities/domain/entities/activity_type_entity.dart';

class ActivityTypeModel extends ActivityTypeEntity {
  const ActivityTypeModel({required super.id, super.name});

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) {
    return ActivityTypeModel(id: json['id'] as int, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
