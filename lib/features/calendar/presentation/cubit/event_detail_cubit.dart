import 'package:andersen/features/calendar/domain/usecase/get_event_detail_usecase.dart';
import 'package:andersen/features/calendar/presentation/cubit/event_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final GetEventDetailUsecase usecase;

  EventDetailCubit(this.usecase) : super(EventDetailInitial());

  Future<void> getEventDetail(int eventId) async {
    emit(EventDetailLoading());
    final result = await usecase.call(eventId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(EventDetailError(failure.message)),
      (event) => emit(EventDetailLoaded(event)),
    );
  }
}
