import 'package:andersen/features/tasks/domain/entities/task_type_entity.dart';

class TaskTypeModel extends TaskTypeEntity {
  const TaskTypeModel({required super.id, super.name});

  factory TaskTypeModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeModel(id: json['id'] as int, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
