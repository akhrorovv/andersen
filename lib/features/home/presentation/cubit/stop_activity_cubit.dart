import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/domain/usecases/stop_activity_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// state
abstract class StopActivityState {}

class StopActivityInitial extends StopActivityState {}

class StopActivityLoading extends StopActivityState {}

class StopActivitySuccess extends StopActivityState {
  final ActivityEntity activity;

  StopActivitySuccess(this.activity);
}

class StopActivityError extends StopActivityState {
  final String message;

  StopActivityError(this.message);
}

// cubit
class StopActivityCubit extends Cubit<StopActivityState> {
  final StopActivityUsecase usecase;

  StopActivityCubit(this.usecase) : super(StopActivityInitial());

  Future<void> stopActivity(int activityId, Map<String, dynamic> body) async {
    emit(StopActivityLoading());

    final result = await usecase.call(activityId, body);

    result.fold(
      (failure) => emit(StopActivityError(failure.message)),
      (activity) => emit(StopActivitySuccess(activity)),
    );
  }
}
