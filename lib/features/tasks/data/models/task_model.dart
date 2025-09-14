import 'package:andersen/features/home/data/models/user_model.dart';
import 'package:andersen/features/tasks/data/models/activity_model.dart';
import 'package:andersen/features/tasks/data/models/matter_model.dart';
import 'package:andersen/features/tasks/data/models/task_type_model.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    super.description,
    required super.status,
    required super.priority,
    super.dueAt,
    super.activities,
    super.matter,
    super.createdBy,
    super.assignedStaff,
    super.type,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      description: json['description'] as String?,
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      dueAt: json['dueAt'] != null ? DateTime.tryParse(json['dueAt']) : null,
      activities:
          (json['activities'] as List<dynamic>?)
              ?.map((a) => ActivityModel.fromJson(a))
              .toList() ??
          [],
      matter: json['matter'] != null
          ? MatterModel.fromJson(json['matter'])
          : null,
      createdBy: json['createdBy'] != null
          ? UserModel.fromJson(json['createdBy'])
          : null,
      assignedStaff: json['assignedStaff'] != null
          ? UserModel.fromJson(json['assignedStaff'])
          : null,
      type: json['type'] != null ? TaskTypeModel.fromJson(json['type']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'priority': priority,
      'dueAt': dueAt?.toIso8601String(),
      'activities': activities
          ?.map((a) => (a as ActivityModel).toJson())
          .toList(),
      'matter': (matter as MatterModel?)?.toJson(),
      'createdBy': (createdBy as UserModel?)?.toJson(),
      'assignedStaff': (assignedStaff as UserModel?)?.toJson(),
      'type': (type as TaskTypeModel?)?.toJson(),
    };
  }
}
