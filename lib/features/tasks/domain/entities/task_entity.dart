import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_type_entity.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueAt;
  final List<ActivityEntity>? activities;
  final MatterEntity? matter;
  final UserEntity? createdBy;
  final UserEntity? assignedStaff;
  final TaskTypeEntity? type;

  const TaskEntity({
    required this.id,
    this.description,
    required this.status,
    required this.priority,
    this.dueAt,
    this.activities,
    this.matter,
    this.createdBy,
    this.assignedStaff,
    this.type,
  });

  @override
  List<Object?> get props => [
    id,
    description,
    status,
    priority,
    dueAt,
    activities,
    matter,
    createdBy,
    assignedStaff,
    type,
  ];
}
