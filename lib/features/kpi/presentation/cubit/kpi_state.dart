import 'package:andersen/features/kpi/domain/entities/kpi_results_entity.dart';
import 'package:equatable/equatable.dart';

abstract class KpiState extends Equatable {
  const KpiState();

  @override
  List<Object?> get props => [];
}

class KpiInitial extends KpiState {}

class KpiLoading extends KpiState {}

class KpiLoadedSuccess extends KpiState {
  final KpiResultsEntity resultsEntity;

  const KpiLoadedSuccess(this.resultsEntity);

  @override
  List<Object?> get props => [resultsEntity];
}

class KpiLoadedError extends KpiState {
  final String message;

  const KpiLoadedError(this.message);

  @override
  List<Object?> get props => [message];
}
