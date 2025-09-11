import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/tasks_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase getTasksUseCase;

  TasksCubit(this.getTasksUseCase) : super(TasksInitial());

  static const int _limit = 20;
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<TaskEntity> _allTasks = [];

  Future<void> getTasks({bool refresh = false}) async {
    if (refresh) {
      emit(TasksLoading());
      _offset = 0;
      _allTasks = [];
      _hasMore = true;
    }

    if (!_hasMore) return;

    final result = await getTasksUseCase(limit: _limit, offset: _offset);

    result.fold((failure) => emit(TasksError(failure.message)), (tasks) {
      if (_offset + _limit >= tasks.meta.total) {
        _hasMore = false;
      }

      _allTasks.addAll(tasks.results);

      emit(
        TasksLoaded(TasksEntity(meta: tasks.meta, results: List.of(_allTasks))),
      );

      _offset += _limit;
    });
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getTasks();
    _isLoadingMore = false;
  }
}
