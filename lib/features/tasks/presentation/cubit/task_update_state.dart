import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TaskUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskUpdateInitial extends TaskUpdateState {}

class TaskUpdateLoading extends TaskUpdateState {}

class TaskUpdateSuccess extends TaskUpdateState {
  final TaskEntity task;

  TaskUpdateSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdateError extends TaskUpdateState {
  final String message;

  TaskUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
