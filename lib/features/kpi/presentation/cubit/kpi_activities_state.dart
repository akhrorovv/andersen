import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:equatable/equatable.dart';

abstract class KpiActivitiesState extends Equatable {
  const KpiActivitiesState();

  @override
  List<Object?> get props => [];
}

class KpiActivitiesInitial extends KpiActivitiesState {}

class KpiActivitiesLoading extends KpiActivitiesState {}

class KpiActivitiesLoaded extends KpiActivitiesState {
  final ActivitiesEntity activities;

  const KpiActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class KpiActivitiesError extends KpiActivitiesState {
  final String message;

  const KpiActivitiesError(this.message);

  @override
  List<Object?> get props => [message];
}
