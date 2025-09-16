import 'package:flutter/material.dart';

class KpiPage extends StatelessWidget {
  static String path = '/kpi';

  const KpiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),

        body: Center(child: Text("KPI Page")));
  }
}
