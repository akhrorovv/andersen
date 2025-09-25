import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final EventsEntity events;
  final List<DayEvents> days;
  final EventTarget? target;

  const EventsLoaded(this.events, this.days, {this.target});

  @override
  List<Object?> get props => [events, days, target];
}


class EventsError extends EventsState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object?> get props => [message];
}
