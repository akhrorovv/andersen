import 'package:andersen/features/calendar/domain/usecase/delete_event_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// state
abstract class DeleteEventState extends Equatable {
  const DeleteEventState();

  @override
  List<Object?> get props => [];
}

class DeleteEventInitial extends DeleteEventState {}

class DeleteEventLoading extends DeleteEventState {}

class DeleteEventSuccess extends DeleteEventState {
  final bool success;

  const DeleteEventSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

class DeleteEventError extends DeleteEventState {
  final String message;

  const DeleteEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// cubit

class DeleteEventCubit extends Cubit<DeleteEventState> {
  final DeleteEventUsecase usecase;

  DeleteEventCubit(this.usecase) : super(DeleteEventInitial());

  Future<void> deleteEvent(int eventId) async {
    emit(DeleteEventLoading());
    final result = await usecase.call(eventId);
    result.fold(
      (failure) => emit(DeleteEventError(failure.message)),
      (success) => emit(DeleteEventSuccess(success)),
    );
  }
}
