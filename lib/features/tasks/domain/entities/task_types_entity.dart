import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_type_entity.dart';
import 'package:equatable/equatable.dart';

class TaskTypesEntity extends Equatable {
  final MetaEntity meta;
  final List<TaskTypeEntity> types;

  const TaskTypesEntity({required this.meta, required this.types});

  @override
  List<Object?> get props => [meta, types];
}
