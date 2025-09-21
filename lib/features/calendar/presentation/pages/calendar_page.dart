import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/widgets/custom_calendar.dart';
import 'package:andersen/features/calendar/presentation/widgets/day_events_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  static String path = '/calendar';

  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Column(
        children: [
          /// Calendar
          CustomCalendar<EventEntity>(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
              context.read<EventsCubit>().getEvents(focusedDay: focusedDay, refresh: true);
            },
            eventLoader: (day) => [],
          ),

          /// Events
          Expanded(
            child: BlocBuilder<EventsCubit, EventsState>(
              builder: (context, state) {
                if (state is EventsInitial || state is EventsLoading) {
                  return const LoadingIndicator();
                } else if (state is EventsError) {
                  return ErrorMessage(errorMessage: state.message);
                } else if (state is EventsLoaded) {
                  final days = state.days;
                  return ScrollablePositionedList.builder(
                    itemScrollController: scrollController,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      return DayEventsSection(day: day.day, events: day.events);
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum EventTarget { firmEvent, newClient, caseMeeting }

extension EventTargetX on EventTarget {
  String get label {
    switch (this) {
      case EventTarget.firmEvent:
        return "Company Event";
      case EventTarget.newClient:
        return "New Client";
      case EventTarget.caseMeeting:
        return "Case Meeting";
    }
  }

  String get apiValue {
    switch (this) {
      case EventTarget.firmEvent:
        return "FIRM_EVENT";
      case EventTarget.newClient:
        return "NEW_CLIENT";
      case EventTarget.caseMeeting:
        return "CASE_MEETING";
    }
  }

  static EventTarget fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "FIRM_EVENT":
        return EventTarget.firmEvent;
      case "NEW_CLIENT":
        return EventTarget.newClient;
      case "CASE_MEETING":
        return EventTarget.caseMeeting;
      default:
        throw ArgumentError("Unknown EventTarget: $value");
    }
  }
}
