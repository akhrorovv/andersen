import 'dart:async';

import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/domain/usecases/get_active_activity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityStatusCubit extends Cubit<ActivityStatusState> {
  final GetActiveActivity useCase;
  Timer? _timer;

  ActivityStatusCubit(this.useCase) : super(ActivityStatusInitial());

  Future<void> checkActiveActivity() async {
    emit(ActivityStatusLoading());
    try {
      final result = await useCase();

      result.fold(
        (failure) {
          emit(ActivityStatusError(failure.message));
        },
        (activity) {
          if (activity == null) {
            emit(ActivityStatusInactive());
          } else {
            final startTime = activity.lastStartTime;
            if (startTime == null) {
              emit(ActivityStatusError("Activity start time yo‘q"));
              return;
            }

            // Boshlang‘ich diff
            var diff = DateTime.now().toUtc().difference(startTime).inSeconds;

            emit(ActivityStatusActive(activity: activity, elapsedSeconds: diff));

            // Har sekund yangilash
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 1), (t) {
              diff++;
              emit(ActivityStatusActive(activity: activity, elapsedSeconds: diff));
            });
          }
        },
      );
    } catch (e) {
      emit(ActivityStatusError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// state
sealed class ActivityStatusState extends Equatable {
  const ActivityStatusState();

  @override
  List<Object?> get props => [];
}

class ActivityStatusInitial extends ActivityStatusState {}

class ActivityStatusLoading extends ActivityStatusState {}

class ActivityStatusInactive extends ActivityStatusState {}

class ActivityStatusActive extends ActivityStatusState {
  final ActivityEntity activity;
  final int elapsedSeconds;

  const ActivityStatusActive({required this.activity, required this.elapsedSeconds});

  @override
  List<Object?> get props => [activity, elapsedSeconds];
}

class ActivityStatusError extends ActivityStatusState {
  final String message;

  const ActivityStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
