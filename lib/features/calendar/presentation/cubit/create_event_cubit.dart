// state
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/usecase/create_event_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateEventState {}

class CreateEventInitial extends CreateEventState {}

class CreateEventLoading extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {
  final EventEntity event;

  CreateEventSuccess(this.event);
}

class CreateEventError extends CreateEventState {
  final String message;

  CreateEventError(this.message);
}

// cubit
class CreateEventCubit extends Cubit<CreateEventState> {
  final CreateEventUsecase usecase;

  CreateEventCubit(this.usecase) : super(CreateEventInitial());

  Future<void> createEvent(Map<String, dynamic> body) async {
    emit(CreateEventLoading());

    final result = await usecase.call(body);

    result.fold(
      (failure) => emit(CreateEventError(failure.message)),
      (event) => emit(CreateEventSuccess(event)),
    );
  }
}
