import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivityDetailState extends Equatable {
  const ActivityDetailState();

  @override
  List<Object?> get props => [];
}

class ActivityDetailInitial extends ActivityDetailState {}

class ActivityDetailLoading extends ActivityDetailState {}

class ActivityDetailLoaded extends ActivityDetailState {
  final ActivityEntity activity;

  const ActivityDetailLoaded(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityDetailError extends ActivityDetailState {
  final String message;

  const ActivityDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
