// state
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/create_task_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateTaskState {}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final TaskEntity task;

  CreateTaskSuccess(this.task);
}

class CreateTaskError extends CreateTaskState {
  final String message;

  CreateTaskError(this.message);
}

// cubit
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskUsecase usecase;

  CreateTaskCubit(this.usecase) : super(CreateTaskInitial());

  Future<void> createTask(Map<String, dynamic> body) async {
    emit(CreateTaskLoading());

    final result = await usecase.call(body);

    result.fold(
      (failure) => emit(CreateTaskError(failure.message)),
      (task) => emit(CreateTaskSuccess(task)),
    );
  }
}
