import 'package:andersen/features/kpi/domain/entities/complaint_entity.dart';
import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/complaints_repository.dart';
import 'package:andersen/features/kpi/domain/usecase/get_complaints_usecase.dart';
import 'package:andersen/features/kpi/presentation/cubit/complaints_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final GetComplaintsUsecase usecase;

  ComplaintsCubit(this.usecase) : super(ComplaintsInitial());

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;

  List<ComplaintEntity> _complaints = [];
  bool _hasMore = true;
  ComplaintsRequest? _lastRequest;

  Future<void> getComplaints({bool refresh = false, required ComplaintsRequest request}) async {
    if (refresh) {
      _offset = 0;
      _complaints = [];
      _hasMore = true;
      emit(ComplaintsLoading());
    }

    _lastRequest = request;
    if (!_hasMore) return;

    final result = await usecase.call(request: request);

    result.fold(
      (failure) {
        emit(ComplaintsError(failure.message));
      },
      (complaints) {
        _complaints = [..._complaints, ...complaints.results];
        _hasMore = _offset + _limit < complaints.meta.total;

        emit(ComplaintsLoaded(ComplaintsEntity(results: _complaints, meta: complaints.meta)));

        _offset += _limit;
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await getComplaints(request: _lastRequest!);
    _isLoadingMore = false;
  }
}
