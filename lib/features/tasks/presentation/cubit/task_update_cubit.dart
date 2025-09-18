import 'package:andersen/features/tasks/domain/usecase/update_task_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskUpdateCubit extends Cubit<TaskUpdateState> {
  final UpdateTaskUsecase updateTaskUseCase;

  TaskUpdateCubit(this.updateTaskUseCase) : super(TaskUpdateInitial());

  // Future<void> getClients(int taskId, Map<String, dynamic> body) async {
  //   emit(TaskUpdateLoading());
  //
  //   final result = await updateTaskUseCase.call(taskId, body);
  //
  //   result.fold(
  //     (failure) => emit(TaskUpdateError(failure.message)),
  //     (task) => emit(TaskUpdateSuccess(task)),
  //   );
  // }

  Future<void> updateTask(int taskId, Map<String, dynamic> body) async {
    emit(TaskUpdateLoading());

    final result = await updateTaskUseCase.call(taskId, body);

    result.fold(
      (failure) => emit(TaskUpdateError(failure.message)),
      (task) => emit(TaskUpdateSuccess(task)),
    );
  }
}
