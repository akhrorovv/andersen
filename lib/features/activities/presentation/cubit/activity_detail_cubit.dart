import 'package:andersen/features/activities/domain/usecase/get_activity_detail_usecase.dart';
import 'package:andersen/features/activities/presentation/cubit/activity_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  final GetActivityDetailUsecase getActivityDetailUsecase;

  ActivityDetailCubit(this.getActivityDetailUsecase)
    : super(ActivityDetailInitial());

  Future<void> getActivityDetail(int activityId) async {
    emit(ActivityDetailLoading());
    final result = await getActivityDetailUsecase.call(activityId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(ActivityDetailError(failure.message)),
      (activity) => emit(ActivityDetailLoaded(activity)),
    );
  }
}
