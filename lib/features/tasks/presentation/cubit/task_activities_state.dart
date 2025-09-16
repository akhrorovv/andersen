import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TaskActivitiesState extends Equatable {
  const TaskActivitiesState();

  @override
  List<Object?> get props => [];
}

class TaskActivitiesInitial extends TaskActivitiesState {}

class TaskActivitiesLoading extends TaskActivitiesState {}

class TaskActivitiesLoaded extends TaskActivitiesState {
  final ActivitiesEntity activities;

  const TaskActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class TaskActivitiesError extends TaskActivitiesState {
  final String message;

  const TaskActivitiesError(this.message);

  @override
  List<Object?> get props => [message];
}
