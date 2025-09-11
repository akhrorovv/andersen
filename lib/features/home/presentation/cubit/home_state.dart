import 'package:andersen/features/home/domain/entities/active_status_entity.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserEntity user;
  final ActiveStatusEntity status;

  const HomeLoaded(this.user, this.status);

  @override
  List<Object?> get props => [user, status];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
