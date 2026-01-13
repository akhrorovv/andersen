import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_user_repository.dart';
import 'package:andersen/features/kpi/domain/usecase/get_user_kpi_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KpiUserCubit extends Cubit<KpiUserState> {
  final GetUserKpiUsecase usecase;

  KpiUserCubit(this.usecase) : super(KpiUserInitial());

  Future<void> getUserKpi(int userId, KpiUserRequest request) async {
    emit(KpiUserLoading());
    final result = await usecase.call(userId, request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(KpiUserLoadedError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (userKpi) => emit(KpiUserLoadedSuccess(userKpi)),
    );
  }
}
