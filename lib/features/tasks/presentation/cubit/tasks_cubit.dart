import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/get_tasks_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase getTasksUseCase;

  TasksCubit(this.getTasksUseCase) : super(TasksInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  TaskStatus? _selectedStatus;
  String? _searchQuery;
  List<TaskEntity> _tasks = [];
  bool _hasMore = true;

  Future<void> changeStatus(TaskStatus status) async {
    _offset = 0;
    _tasks = [];
    _hasMore = true;
    _selectedStatus = status;

    emit(TasksLoading());
    await getTasks(refresh: true, status: status);
  }

  Future<void> searchTasks(String query) async {
    _offset = 0;
    _tasks = [];
    _hasMore = true;
    _searchQuery = query.isEmpty ? null : query;

    emit(TasksLoading());
    await getTasks(
      refresh: true,
      status: _selectedStatus,
      search: _searchQuery,
    );
  }

  Future<void> clearSearch() async {
    _searchQuery = null;
    _offset = 0;
    await getTasks(
      refresh: true,
      status: _selectedStatus,
      search: _searchQuery,
    );
  }

  Future<void> getTasks({
    bool refresh = false,
    TaskStatus? status,
    String? search,
  }) async {
    if (refresh) {
      _offset = 0;
      _tasks = [];
      _hasMore = true;
      _selectedStatus = status ?? _selectedStatus;
      _searchQuery = search ?? _searchQuery;
      emit(TasksLoading());
    }

    if (!_hasMore) return;

    final result = await getTasksUseCase(
      limit: _limit,
      offset: _offset,
      status: (status ?? _selectedStatus)?.apiValue,
      search: search ?? _searchQuery,
    );

    result.fold(
      (failure) {
        emit(TasksError(failure.message));
      },
      (tasksEntity) {
        _tasks = [..._tasks, ...tasksEntity.results];
        _hasMore = _offset + _limit < tasksEntity.meta.total;

        emit(TasksLoaded(TasksEntity(results: _tasks, meta: tasksEntity.meta)));

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getTasks();
    _isLoadingMore = false;
  }
}
