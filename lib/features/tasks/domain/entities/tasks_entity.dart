import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class TasksEntity extends Equatable {
  final MetaEntity meta;
  final List<TaskEntity> results;

  const TasksEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}

