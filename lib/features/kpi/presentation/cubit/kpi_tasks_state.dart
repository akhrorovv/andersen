import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:equatable/equatable.dart';

abstract class KpiTasksState extends Equatable {
  const KpiTasksState();

  @override
  List<Object?> get props => [];
}

class KpiTasksInitial extends KpiTasksState {}

class KpiTasksLoading extends KpiTasksState {}

class KpiTasksLoaded extends KpiTasksState {
  final TasksEntity tasks;

  const KpiTasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class KpiTasksError extends KpiTasksState {
  final String message;
  final bool isNetworkError;

  const KpiTasksError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
