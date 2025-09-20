import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/widgets/custom_calendar.dart';
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
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
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

              // context.read<EventsCubit>().getEvents(focusedDay: focusedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;

              context.read<EventsCubit>().getEvents(focusedDay: focusedDay);
            },
            eventLoader: (day) {
              return [];
            },
          ),

          /// Events
          // Expanded(
          //   child: ScrollablePositionedList.builder(
          //     itemScrollController: scrollController,
          //     itemCount: itemCount,
          //     itemBuilder: (context, index){
          //
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
