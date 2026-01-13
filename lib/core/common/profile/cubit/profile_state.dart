import 'package:andersen/core/common/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadedSuccess extends ProfileState {
  final UserEntity user;

  const ProfileLoadedSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileLoadedError extends ProfileState {
  final String message;
  final bool isNetworkError;

  const ProfileLoadedError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
