import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/create_event_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/pages/create_event_page.dart';
import 'package:andersen/features/calendar/presentation/widgets/custom_calendar.dart';
import 'package:andersen/features/calendar/presentation/widgets/day_events_section.dart';
import 'package:andersen/features/tasks/presentation/cubit/create_task_cubit.dart';
import 'package:andersen/features/tasks/presentation/pages/create_task_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final ItemScrollController scrollController = ItemScrollController();

  void _scrollToSelectedDay({int retry = 0}) {
    final state = context.read<EventsCubit>().state;
    if (state is! EventsLoaded) return;

    final days = state.days;
    final index = days.indexWhere((d) => isSameDay(d.day, _selectedDay));

    if (index == -1) return;

    // safety: ItemScrollController has `isAttached`
    if (scrollController.isAttached) {
      scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return;
    }

    // agar hali attach bo'lmagan bo'lsa, keyingi frame da qayta urin
    if (retry < 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scrollToSelectedDay(retry: retry + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM').format(_focusedDay)),
        actions: [
          TextButton(
            onPressed: () async {
              final created = await context.pushCupertinoSheet<bool>(
                BlocProvider(create: (_) => sl<CreateEventCubit>(), child: CreateEventPage()),
              );
              if (context.mounted && created == true) {
                context.read<EventsCubit>().getEvents(refresh: true);
              }
            },
            child: Text(
              "New event",
              style: TextStyle(color: AppColors.white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
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

              _scrollToSelectedDay();
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

            eventLoader: (day) {
              final state = context.read<EventsCubit>().state;
              if (state is EventsLoaded) {
                final events = state.events.events;
                return events
                    .where((e) => e.startsAt != null && isSameDay(e.startsAt, day))
                    .toList();
              }
              return [];
            },
          ),

          /// Events
          Expanded(
            child: BlocListener<EventsCubit, EventsState>(
              listener: (context, state) {
                if (state is EventsLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    _scrollToSelectedDay();
                  });
                }
              },
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
          ),
        ],
      ),
    );
  }
}
