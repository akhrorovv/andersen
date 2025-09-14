import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:equatable/equatable.dart';

sealed class MatterState extends Equatable {
  const MatterState();

  @override
  List<Object?> get props => [];
}

final class MatterInitial extends MatterState {}

final class MatterLoading extends MatterState {}

final class MatterLoaded extends MatterState {
  final MattersEntity matters;

  const MatterLoaded(this.matters);

  @override
  List<Object?> get props => [matters];
}

final class MatterError extends MatterState {
  final String message;

  const MatterError(this.message);

  @override
  List<Object?> get props => [message];
}
