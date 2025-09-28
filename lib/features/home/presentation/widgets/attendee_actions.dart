import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/home/presentation/cubit/attendee_cubit.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendeeActions {
  /// 🔹 Has Come
  static Future<void> handleArrive(BuildContext context) async {
    try {
      // service enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        if (!context.mounted) return;
        return;
      }

      // permission
      final hasPermission = await _handleLocationPermission(context);
      if (!hasPermission || !context.mounted) return;

      // location
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!context.mounted) return;

      // late check
      final now = DateTime.now();
      final isLate = now.hour > 9 || (now.hour == 9 && now.minute > 0);

      if (isLate) {
        final reason = await context.pushCupertinoSheet(ReasonPage());
        if (reason != null && reason is String && reason.isNotEmpty) {
          context.read<AttendeeCubit>().arrive(
            latitude: position.latitude,
            longitude: position.longitude,
            lateReason: reason,
          );
        } else {
          BasicSnackBar.show(context, message: "Please provide a reason");
        }
      } else {
        context.read<AttendeeCubit>().arrive(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      BasicSnackBar.show(context, message: "Error: $e", error: true);
    }
  }

  /// 🔹 Has Left
  static Future<void> handleLeave(BuildContext context) async {
    try {
      final now = DateTime.now();
      final isEarly = now.hour < 18;

      if (isEarly) {
        final reason = await context.pushCupertinoSheet(ReasonPage());
        if (reason != null && reason is String && reason.isNotEmpty) {
          context.read<AttendeeCubit>().leave(earlyReason: reason);
        }
      } else {
        context.read<AttendeeCubit>().leave();
      }
    } catch (e) {
      if (!context.mounted) return;
      BasicSnackBar.show(context, message: "Error: $e", error: true);
    }
  }

  /// 🔹 Permission checker
  static Future<bool> _handleLocationPermission(BuildContext context) async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!context.mounted) return false;
        BasicSnackBar.show(context, message: "Location permission is required", error: true);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) return false;
      BasicSnackBar.show(context, message: "Please enable location in settings");
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }
}
