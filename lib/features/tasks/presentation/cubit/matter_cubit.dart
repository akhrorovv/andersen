import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:andersen/features/tasks/domain/usecase/get_matters_usecase.dart';
import 'package:andersen/features/tasks/presentation/cubit/matter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatterCubit extends Cubit<MatterState> {
  final GetMattersUsecase getMattersUsecase;

  MatterCubit(this.getMattersUsecase) : super(MatterInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  String? _searchQuery;
  List<MatterEntity> _matters = [];
  bool _hasMore = true;

  Future<void> getMatters({bool refresh = false, String? search}) async {
    if (refresh) {
      _offset = 0;
      _matters = [];
      _hasMore = true;
      _searchQuery = search ?? _searchQuery;
      emit(MatterLoading());
    }

    if (!_hasMore) return;

    final result = await getMattersUsecase(
      limit: _limit,
      offset: _offset,
      taskCreatable: true,
      search: search ?? _searchQuery,
    );

    result.fold(
      (failure) {
        emit(MatterError(failure.message));
      },
      (tasksEntity) {
        _matters = [..._matters, ...tasksEntity.results];
        _hasMore = _offset + _limit < tasksEntity.meta.total;

        emit(
          MatterLoaded(MattersEntity(results: _matters, meta: tasksEntity.meta)),
        );

        _offset += _limit;
      },
    );
  }

  Future<void> searchTasks(String query) async {
    _offset = 0;
    _matters = [];
    _hasMore = true;
    _searchQuery = query.isEmpty ? null : query;

    emit(MatterLoading());
    await getMatters(
      refresh: true,
      search: _searchQuery,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getMatters();
    _isLoadingMore = false;
  }
}
