import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.tr('noItemsFound')));
  }
}
