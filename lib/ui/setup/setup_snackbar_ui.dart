import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/snackbar_type.dart';

import 'package:stacked_services/stacked_services.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  SnackbarConfig config = SnackbarConfig(
    messageTextAlign: TextAlign.center,
    titleTextAlign: TextAlign.center,
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: true,
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    snackStyle: SnackStyle.GROUNDED,
    margin: kIsWeb
        ? const EdgeInsets.only(
            bottom: 30,
          )
        : const EdgeInsets.all(0),
    maxWidth: kIsWeb ? 500 : double.infinity,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 100,
        offset: const Offset(0, 10),
      ),
    ],
    overlayBlur: 2,
    animationDuration: const Duration(milliseconds: 200),
    // dismissDirection: SnackDismissDirection.VERTICAL,
  );

  SnackbarConfig errorConfig = SnackbarConfig(
    messageTextAlign: TextAlign.center,
    titleTextAlign: TextAlign.center,
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: false,
    titleColor: Colors.black,
    messageColor: Colors.black,
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    margin: kIsWeb
        ? const EdgeInsets.only(
            bottom: 30,
          )
        : const EdgeInsets.all(0),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 100,
        offset: const Offset(0, 10),
      ),
    ],
    backgroundColor: Colors.amber,
    overlayBlur: 2,
    maxWidth: kIsWeb ? 500 : double.infinity,
    snackStyle: SnackStyle.GROUNDED,
    animationDuration: const Duration(milliseconds: 200),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: errorConfig
      ..backgroundColor = Colors.green.shade600
      ..titleColor = Colors.white
      ..messageColor = Colors.white
      ..padding = const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.normal,
    config: config
      ..backgroundColor = Colors.white
      ..textColor = Colors.black
      ..padding = const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
  );
}
