import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TaskDetailState extends Equatable {
  const TaskDetailState();

  @override
  List<Object?> get props => [];
}

class TaskDetailInitial extends TaskDetailState {}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final TaskEntity task;

  const TaskDetailLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDetailError extends TaskDetailState {
  final String message;

  const TaskDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
