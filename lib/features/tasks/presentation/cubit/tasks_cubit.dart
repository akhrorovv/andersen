import 'package:andersen/features/tasks/domain/usecase/tasks_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase getTasksUseCase;

  TasksCubit(this.getTasksUseCase) : super(TasksInitial());

  Future<void> getTasks() async {
    emit(TasksLoading());

    final tasksResult = await getTasksUseCase();

    tasksResult.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }
}
