import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/usecase/update_event_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// state
abstract class UpdateEventState {}

class UpdateEventInitial extends UpdateEventState {}

class UpdateEventLoading extends UpdateEventState {}

class UpdateEventSuccess extends UpdateEventState {
  final EventEntity event;

  UpdateEventSuccess(this.event);
}

class UpdateEventError extends UpdateEventState {
  final String message;

  UpdateEventError(this.message);
}

// cubit
class UpdateEventCubit extends Cubit<UpdateEventState> {
  final UpdateEventUsecase usecase;

  UpdateEventCubit(this.usecase) : super(UpdateEventInitial());

  Future<void> updateEvent(int eventId, Map<String, dynamic> body) async {
    emit(UpdateEventLoading());

    final result = await usecase.call(eventId, body);

    result.fold(
      (failure) => emit(UpdateEventError(failure.message)),
      (event) => emit(UpdateEventSuccess(event)),
    );
  }
}
