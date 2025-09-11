import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  static String path = '/activities';

  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Activities Page"),
      ),
    );
  }
}
