import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ComplaintsState extends Equatable {
  const ComplaintsState();

  @override
  List<Object?> get props => [];
}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsLoaded extends ComplaintsState {
  final ComplaintsEntity complaints;

  const ComplaintsLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class ComplaintsError extends ComplaintsState {
  final String message;

  const ComplaintsError(this.message);

  @override
  List<Object?> get props => [message];
}
