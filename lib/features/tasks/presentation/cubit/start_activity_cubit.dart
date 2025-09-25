import 'package:andersen/features/tasks/domain/usecase/start_activity_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ActivityStartCubit extends Cubit<ActivityStartState> {
  final StartActivityUsecase startActivityUseCase;

  ActivityStartCubit(this.startActivityUseCase) : super(ActivityStartInitial());

  Future<void> startActivity(Map<String, dynamic> body) async {
    emit(ActivityStartLoading());
    final result = await startActivityUseCase.call(body);

    result.fold(
      (failure) => emit(ActivityStartFailure(failure.message)),
      (_) => emit(ActivityStartSuccess()),
    );
  }
}

abstract class ActivityStartState extends Equatable {
  const ActivityStartState();

  @override
  List<Object?> get props => [];
}

class ActivityStartInitial extends ActivityStartState {}

class ActivityStartLoading extends ActivityStartState {}

class ActivityStartSuccess extends ActivityStartState {}

class ActivityStartFailure extends ActivityStartState {
  final String message;

  const ActivityStartFailure(this.message);

  @override
  List<Object?> get props => [message];
}
