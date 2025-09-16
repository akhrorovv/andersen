import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  static String path = '/calendar';

  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Center(
        child: Text("Calendar Page"),
      ),
    );
  }
}
