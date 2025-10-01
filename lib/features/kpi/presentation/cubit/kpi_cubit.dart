import 'package:andersen/features/kpi/domain/repositories/kpi_repository.dart';
import 'package:andersen/features/kpi/domain/usecase/get_kpi_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KpiCubit extends Cubit<KpiState> {
  final GetKpiUsecase usecase;

  KpiCubit(this.usecase) : super(KpiInitial());

  Future<void> geKpi(KpiRequest request) async {
    emit(KpiLoading());
    final result = await usecase.call(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(KpiLoadedError(failure.message)),
      (userKpi) => emit(KpiLoadedSuccess(userKpi)),
    );
  }
}
