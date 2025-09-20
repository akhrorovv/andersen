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

  static const int _limit = 100;
  int _offset = 0;
  String? _searchQuery;
  String? _target;
  int? _matterId;
  DateTime _focusedDay = DateTime.now();

  List<EventEntity> _events = [];

  Future<void> getEvents({
    bool refresh = false,
    String? search,
    String? target,
    int? matterId,
    DateTime? focusedDay,
  }) async {
    if (refresh) {
      _offset = 0;
      _events.clear();
    }

    if (search != null) _searchQuery = search;
    if (target != null) _target = target;
    if (matterId != null) _matterId = matterId;
    if (focusedDay != null) _focusedDay = focusedDay;

    emit(EventsLoading());

    final dateMin = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final dateMax = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    final result = await getEventsUsecase.call(
      limit: _limit,
      offset: _offset,
      attendeeId: DBService.user!.id,
      dateMin: '${dateMin.toIso8601String()}Z',
      dateMax: '${dateMax.toIso8601String()}Z',
      search: _searchQuery,
      target: _target,
      matterId: _target == "CASE_MEETING" ? _matterId : null,
    );

    result.fold(
      (failure) {
        emit(EventsError(failure.message));
      },
      (result) {
        _events = [..._events, ...result.events];
        _offset += _limit;

        emit(EventsLoaded(EventsEntity(events: _events, meta: result.meta)));
      },
    );
  }

  Map<DateTime, List<EventEntity>> groupEventsByDay(List<EventEntity> events) {
    final Map<DateTime, List<EventEntity>> result = {};

    for (final e in events) {
      // startsAt bo'lmasa createdAt yoki updatedAt dan foydalanamiz
      final DateTime? raw = e.startsAt ?? e.createdAt ?? e.updatedAt;
      if (raw == null) continue; // sana yo'q bo'lsa o'tkazib yuborish

      final day = _dateOnly(raw.toLocal()); // local time ga o'tkazib normalizatsiya qilamiz
      result.putIfAbsent(day, () => []).add(e);
    }

    return result;
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}

class DayEvents {
  final DateTime day;
  final List<EventEntity> events;

  DayEvents({required this.day, required this.events});
}
