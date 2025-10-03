import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/kpi/domain/usecase/get_kpi_activities_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_activities_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KpiActivitiesCubit extends Cubit<KpiActivitiesState> {
  final GetKpiActivitiesUsecase usecase;

  KpiActivitiesCubit(this.usecase) : super(KpiActivitiesInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  List<ActivityEntity> _activities = [];
  bool _hasMore = true;

  Future<void> getActivities({
    bool refresh = false,
    required String startDate,
    required String endDate,
  }) async {
    if (refresh) {
      _offset = 0;
      _activities = [];
      _hasMore = true;
      emit(KpiActivitiesLoading());
    }

    if (!_hasMore) return;

    final result = await usecase.call(
      limit: _limit,
      offset: _offset,
      createdById: DBService.user!.id,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) {
        emit(KpiActivitiesError(failure.message));
      },
      (activitiesEntity) {
        _activities = [..._activities, ...activitiesEntity.results];
        _hasMore = _offset + _limit < activitiesEntity.meta.total;

        emit(
          KpiActivitiesLoaded(ActivitiesEntity(results: _activities, meta: activitiesEntity.meta)),
        );

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore({required String startDate, required String endDate}) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getActivities(startDate: startDate, endDate: endDate);
    _isLoadingMore = false;
  }
}
