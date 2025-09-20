import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/get_task_detail_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailCubit extends Cubit<TaskDetailState> {
  final GetTaskDetailUseCase getTaskDetailUseCase;

  TaskDetailCubit(this.getTaskDetailUseCase) : super(TaskDetailInitial());

  Future<void> getTaskDetail(int taskId) async {
    emit(TaskDetailLoading());
    final result = await getTaskDetailUseCase.call(taskId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(TaskDetailError(failure.message)),
      (task) => emit(TaskDetailLoaded(task)),
    );
  }

  bool isActivityCreatable(TaskEntity task) {
    if (task.matter?.contract?.status == 'CLOSED' ||
        task.matter?.status != "IN_PROGRESS" ||
        task.status == 'DONE') {
      return false;
    }
    return true;
  }
}
