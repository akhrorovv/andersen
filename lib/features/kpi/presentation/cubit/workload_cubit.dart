import 'package:andersen/features/kpi/domain/repositories/workload_repository.dart';
import 'package:andersen/features/kpi/domain/usecase/get_workload_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/workload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkloadCubit extends Cubit<WorkloadState> {
  final GetWorkloadUsecase usecase;

  WorkloadCubit(this.usecase) : super(WorkloadInitial());

  Future<void> getWorkload(WorkloadRequest request) async {
    emit(WorkloadLoading());
    final result = await usecase.call(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(WorkloadLoadedError(failure.message)),
      (workload) => emit(WorkloadLoadedSuccess(workload)),
    );
  }
}
