import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/get_task_activities_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_activities_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskActivitiesCubit extends Cubit<TaskActivitiesState> {
  final GetTaskActivitiesUsecase getTaskActivitiesUsecase;

  TaskActivitiesCubit(this.getTaskActivitiesUsecase)
    : super(TaskActivitiesInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  List<ActivityEntity> _activities = [];
  bool _hasMore = true;

  Future<void> getTaskActivities({
    bool refresh = false,
    required int taskId,
  }) async {
    if (refresh) {
      _offset = 0;
      _activities = [];
      _hasMore = true;
      emit(TaskActivitiesLoading());
    }

    if (!_hasMore) return;

    final result = await getTaskActivitiesUsecase(
      limit: _limit,
      offset: _offset,
      createdById: DBService.user!.id,
      taskId: taskId,
    );

    result.fold(
      (failure) {
        emit(TaskActivitiesError(failure.message));
      },
      (activitiesEntity) {
        _activities = [..._activities, ...activitiesEntity.results];
        _hasMore = _offset + _limit < activitiesEntity.meta.total;

        emit(
          TaskActivitiesLoaded(
            ActivitiesEntity(results: _activities, meta: activitiesEntity.meta),
          ),
        );

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore(int taskId) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getTaskActivities(taskId: taskId);
    _isLoadingMore = false;
  }
}
