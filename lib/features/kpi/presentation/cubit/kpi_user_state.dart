import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class KpiUserState extends Equatable {
  const KpiUserState();

  @override
  List<Object?> get props => [];
}

class KpiUserInitial extends KpiUserState {}

class KpiUserLoading extends KpiUserState {}

class KpiUserLoadedSuccess extends KpiUserState {
  final KpiUserEntity userKpi;

  const KpiUserLoadedSuccess(this.userKpi);

  @override
  List<Object?> get props => [userKpi];
}

class KpiUserLoadedError extends KpiUserState {
  final String message;

  const KpiUserLoadedError(this.message);

  @override
  List<Object?> get props => [message];
}
