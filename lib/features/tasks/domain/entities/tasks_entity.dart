import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class TasksEntity extends Equatable {
  final MetaEntity meta;
  final List<TaskEntity> results;

  const TasksEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}

class MetaEntity extends Equatable {
  final int offset;
  final int limit;
  final int total;

  const MetaEntity({
    required this.offset,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [offset, limit, total];
}
