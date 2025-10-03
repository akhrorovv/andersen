import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/kpi/domain/usecase/get_kpi_tasks_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_tasks_state.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KpiTasksCubit extends Cubit<KpiTasksState> {
  final GetKpiTasksUsecase usecase;

  KpiTasksCubit(this.usecase) : super(KpiTasksInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  List<TaskEntity> _tasks = [];
  bool _hasMore = true;

  Future<void> getTasks({
    bool refresh = false,
    required String startDate,
    required String endDate,
    int? limit,
  }) async {
    if (refresh) {
      _offset = 0;
      _tasks = [];
      _hasMore = true;
      emit(KpiTasksLoading());
    }

    if (!_hasMore) return;

    final result = await usecase.call(
      limit: limit ?? _limit,
      offset: _offset,
      assignedStaffId: DBService.user!.id,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) {
        emit(KpiTasksError(failure.message));
      },
      (tasksEntity) {
        _tasks = [..._tasks, ...tasksEntity.results];
        _hasMore = _offset + _limit < tasksEntity.meta.total;

        emit(KpiTasksLoaded(TasksEntity(results: _tasks, meta: tasksEntity.meta)));

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore({required String startDate, required String endDate}) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getTasks(startDate: startDate, endDate: endDate);
    _isLoadingMore = false;
  }
}
