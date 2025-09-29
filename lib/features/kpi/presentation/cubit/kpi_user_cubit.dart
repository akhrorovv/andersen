import 'package:andersen/features/kpi/domain/usecase/get_user_kpi_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KpiUserCubit extends Cubit<KpiUserState> {
  final GetUserKpiUsecase usecase;

  KpiUserCubit(this.usecase) : super(KpiUserInitial());

  Future<void> getUserKpi(int userId) async {
    emit(KpiUserLoading());
    final result = await usecase.call(userId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(KpiUserLoadedError(failure.message)),
      (userKpi) => emit(KpiUserLoadedSuccess(userKpi)),
    );
  }
}
