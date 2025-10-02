import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WorkloadState extends Equatable {
  const WorkloadState();

  @override
  List<Object?> get props => [];
}

class WorkloadInitial extends WorkloadState {}

class WorkloadLoading extends WorkloadState {}

class WorkloadLoadedSuccess extends WorkloadState {
  final List<WorkloadEntity> workload;

  const WorkloadLoadedSuccess(this.workload);

  @override
  List<Object?> get props => [workload];
}

class WorkloadLoadedError extends WorkloadState {
  final String message;

  const WorkloadLoadedError(this.message);

  @override
  List<Object?> get props => [message];
}
