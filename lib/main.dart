import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/services/material_app_service_service.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/setup/setup_bottom_sheet_ui.dart';
import 'package:news_app_mayank/ui/setup/setup_dialog_ui.dart';
import 'package:news_app_mayank/ui/setup/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  setupSnackbarUi();

  runApp(const MaterialAppWidget());
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MaterialAppWidgetModel>.reactive(
      onDispose: (model) => model.cancelServiceSubscription(),
      builder: (context, model, child) => GestureDetector(
        onTap: () {
          hideKeyboard(
            context: context,
          );
        },
        child: MaterialApp(
          builder: (context, child) {
            return model.isConnected()
                ? child!
                : const Scaffold(
                    body: Center(
                      child: Text(
                        'Not Connected to internet',
                      ),
                    ),
                  );
          },
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: model.getTheme(),
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
        ),
      ),
      viewModelBuilder: () => MaterialAppWidgetModel(),
    );
  }
}

class MaterialAppWidgetModel extends ReactiveViewModel {
  final MaterialAppServiceService _service =
      locator<MaterialAppServiceService>();

  final MaterialThemeServiceService _themeService =
      locator<MaterialThemeServiceService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [
        _service,
        _themeService,
      ];

  ThemeData getTheme() => _themeService.themeData;

  getColorOptions() => _themeService.colorOptions;

  cancelServiceSubscription() {
    _service.subscription?.cancel();
  }

  void handleBrightnessChange() {
    _themeService.handleBrightnessChange();
    notifyListeners();
  }

  void handleColorSelect(int value) {
    _themeService.handleColorSelect(value);
    notifyListeners();
  }

  isConnected() {
    return _service.isConnected;
  }
}
