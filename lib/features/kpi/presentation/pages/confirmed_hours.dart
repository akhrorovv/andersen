import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmedHours extends StatelessWidget {
  const ConfirmedHours({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('confirmedHours')),
      body: EmptyWidget(),
    );
  }
}
