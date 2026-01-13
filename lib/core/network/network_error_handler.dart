import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/network/connectivity_cubit.dart';
import 'package:andersen/core/widgets/no_internet_widget.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';

/// Global singleton that manages network error overlay visibility.
///
/// Shows a full-screen dialog when network error occurs.
/// When user presses "Обновить", emits RetryRequested so all pages can retry.
class NetworkErrorHandler {
  static final NetworkErrorHandler instance = NetworkErrorHandler._();

  NetworkErrorHandler._();

  bool _isShowing = false;

  /// Whether the overlay is currently showing.
  bool get isShowing => _isShowing;

  /// Shows the network error overlay as a full-screen dialog.
  /// Uses root navigator so it appears above everything including sheets.
  void showError() {
    if (_isShowing) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      useSafeArea: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: NoInternetWidget(
              onRetry: () {
                // Close dialog
                Navigator.of(dialogContext).pop();
                _isShowing = false;

                // Emit RetryRequested so all pages can retry their requests
                sl<ConnectivityCubit>().requestRetry();
              },
            ),
          ),
        );
      },
    );
  }

  /// Hides the network error overlay if showing.
  void hideError() {
    if (!_isShowing) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {
      // Ignore if already popped
    }
    _isShowing = false;
  }
}
