import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:flutter/material.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "New task"),
      body: Column(),
    );
  }
}
