import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';
import 'package:andersen/features/calendar/domain/usecase/get_events_usecase.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsCubit extends Cubit<EventsState> {
  final GetEventsUsecase getEventsUsecase;

  EventsCubit(this.getEventsUsecase) : super(EventsInitial());

  static const int _limit = 300;
  int _offset = 0;
  String? _searchQuery;
  EventTarget? _target;
  int? _matterId;
  DateTime _focusedDay = DateTime.now();

  List<EventEntity> _events = [];

  Future<void> getEvents({
    bool refresh = false,
    String? search,
    EventTarget? target,
    int? matterId,
    DateTime? focusedDay,
    String? todayMin,
    String? todayMax,
  }) async {
    if (refresh) {
      _offset = 0;
      _events.clear();
    }

    if (search != null) _searchQuery = search;
    // if (target != null) _target = target;
    _target = target;
    if (matterId != null) _matterId = matterId;
    if (focusedDay != null) _focusedDay = focusedDay;

    emit(EventsLoading());

    final String dateMin;
    final String dateMax;

    if (todayMin != null && todayMax != null) {
      dateMin = todayMin;
      dateMax = todayMax;
    } else {
      final startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
      final endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

      dateMin = '${startOfMonth.toIso8601String()}Z';
      dateMax = '${endOfMonth.toIso8601String()}Z';
    }

    final result = await getEventsUsecase.call(
      limit: _limit,
      offset: _offset,
      attendeeId: DBService.user!.id,
      dateMin: dateMin,
      dateMax: dateMax,
      search: _searchQuery,
      target: _target?.apiValue,
      matterId: _target?.apiValue == "CASE_MEETING" ? _matterId : null,
    );

    result.fold(
      (failure) {
        emit(EventsError(failure.message));
      },
      (result) {
        _events = [..._events, ...result.events];
        _offset += _limit;

        emit(
          EventsLoaded(
            EventsEntity(events: _events, meta: result.meta),
            _mapEventsToDays(_focusedDay, _events),
            target: _target,
          ),
        );
      },
    );
  }

  List<DayEvents> _mapEventsToDays(DateTime focusedDay, List<EventEntity> events) {
    final daysInMonth = DateUtils.getDaysInMonth(focusedDay.year, focusedDay.month);

    return List.generate(daysInMonth, (index) {
      final day = DateTime(focusedDay.year, focusedDay.month, index + 1);

      final dayEvents = events.where((event) {
        final start = event.startsAt;
        return start!.year == day.year && start.month == day.month && start.day == day.day;
      }).toList();

      return DayEvents(day: day, events: dayEvents);
    });
  }
}

class DayEvents {
  final DateTime day;
  final List<EventEntity> events;

  DayEvents({required this.day, required this.events});
}
