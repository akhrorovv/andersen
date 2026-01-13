import 'package:andersen/core/network/connectivity_cubit.dart';
import 'package:andersen/core/network/connectivity_state.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Rating extends StatelessWidget {
  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, connectivityState) {
        if (connectivityState is RetryRequested) {
          // No data to reload for this page
        }
      },
      child: Scaffold(
        appBar: BasicAppBar(title: context.tr('rating')),
        body: EmptyWidget(),
      ),
    );
  }
}
