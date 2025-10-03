import 'dart:async';

import 'package:andersen/core/common/entities/attendee_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/usecases/arrive_attendee_usecase.dart';
import 'package:andersen/features/home/domain/usecases/check_attendee_status_usecase.dart';
import 'package:andersen/features/home/domain/usecases/leave_attendee_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// cubit

class AttendeeCubit extends Cubit<AttendeeState> {
  final CheckAttendeeStatusUsecase checkUsecase;
  final ArriveAttendeeUsecase arriveUsecase;
  final LeaveAttendeeUsecase leaveUsecase;

  AttendeeCubit(this.checkUsecase, this.arriveUsecase, this.leaveUsecase)
    : super(AttendeeStatusInitial());

  Future<void> checkAttendeeStatus() async {
    emit(AttendeeStatusLoading());

    final result = await checkUsecase();

    result.fold((failure) {
      if (failure is ServerFailure && failure.statusCode == 404) {
        emit(AttendeeStatusInactive());
      } else {
        emit(AttendeeStatusError(failure.message));
      }
    }, (attendee) => emit(AttendeeStatusLoaded(attendee)));
  }

  Future<void> arrive({
    required double latitude,
    required double longitude,
    String? lateReason,
  }) async {
    emit(AttendeeArriveLoading());

    final result = await arriveUsecase.call(
      latitude: latitude,
      longitude: longitude,
      lateReason: lateReason,
    );

    result.fold(
      (failure) => emit(AttendeeArriveError(failure.message)),
      (attendee) => emit(AttendeeArriveSuccess(attendee)),
    );
  }

  Future<void> leave({String? earlyReason}) async {
    emit(AttendeeLeaveLoading());

    final result = await leaveUsecase.call(earlyReason: earlyReason);

    result.fold(
      (failure) => emit(AttendeeLeaveError(failure.message)),
      (attendee) => emit(AttendeeLeaveSuccess(attendee)),
    );
  }
}

/// state
abstract class AttendeeState extends Equatable {
  const AttendeeState();

  @override
  List<Object?> get props => [];
}

// check uchun
class AttendeeStatusInitial extends AttendeeState {}

class AttendeeStatusLoading extends AttendeeState {}

class AttendeeStatusLoaded extends AttendeeState {
  final AttendeeEntity attendee;

  const AttendeeStatusLoaded(this.attendee);

  @override
  List<Object?> get props => [attendee];
}

class AttendeeStatusInactive extends AttendeeState {}

class AttendeeStatusError extends AttendeeState {
  final String message;

  const AttendeeStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// arrive uchun
class AttendeeArriveLoading extends AttendeeState {}

class AttendeeArriveSuccess extends AttendeeState {
  final AttendeeEntity attendee;

  const AttendeeArriveSuccess(this.attendee);

  @override
  List<Object?> get props => [attendee];
}

class AttendeeArriveError extends AttendeeState {
  final String message;

  const AttendeeArriveError(this.message);

  @override
  List<Object?> get props => [message];
}

// leave uchun
class AttendeeLeaveLoading extends AttendeeState {}

class AttendeeLeaveSuccess extends AttendeeState {
  final AttendeeEntity attendee;

  const AttendeeLeaveSuccess(this.attendee);

  @override
  List<Object?> get props => [attendee];
}

class AttendeeLeaveError extends AttendeeState {
  final String message;

  const AttendeeLeaveError(this.message);

  @override
  List<Object?> get props => [message];
}
