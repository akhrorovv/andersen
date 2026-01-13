import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object?> get props => [];
}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  final ActivitiesEntity activities;

  const ActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivitiesError extends ActivitiesState {
  final String message;
  final bool isNetworkError;

  const ActivitiesError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
