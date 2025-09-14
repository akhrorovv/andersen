import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/activities/domain/usecase/get_activities_usecase.dart';
import 'package:andersen/features/activities/presentation/cubit/activities_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitiesCubit extends Cubit<ActivitiesState> {
  final GetActivitiesUsecase getActivitiesUsecase;

  ActivitiesCubit(this.getActivitiesUsecase) : super(ActivitiesInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  List<ActivityEntity> _activities = [];
  bool _hasMore = true;

  Future<void> getActivities({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      _activities = [];
      _hasMore = true;
      emit(ActivitiesLoading());
    }

    if (!_hasMore) return;

    final result = await getActivitiesUsecase(limit: _limit, offset: _offset);

    result.fold(
      (failure) {
        emit(ActivitiesError(failure.message));
      },
      (activitiesEntity) {
        _activities = [..._activities, ...activitiesEntity.results];
        _hasMore = _offset + _limit < activitiesEntity.meta.total;

        emit(ActivitiesLoaded(ActivitiesEntity(results: _activities, meta: activitiesEntity.meta)));

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getActivities();
    _isLoadingMore = false;
  }
}
