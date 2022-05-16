import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/bottom_sheet_type.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/ui/common/app_strings.dart';
import 'package:news_app_mayank/ui/views/all_news/all_news_view.dart';
import 'package:news_app_mayank/ui/views/top_headlines/top_headlines_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends ReactiveViewModel {
  final MaterialThemeServiceService _themeService =
      locator<MaterialThemeServiceService>();
  final _bottomSheetService = locator<BottomSheetService>();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  ThemeData getTheme() => _themeService.themeData;
  getColorOptions() => _themeService.colorOptions;

  get getColorTextOptions => _themeService.colorText;
  void handleBrightnessChange() {
    _themeService.handleBrightnessChange();
  }

  void handleColorSelect(int value) {
    return _themeService.handleColorSelect(value);
  }

  useLightMode() {
    return _themeService.useLightMode;
  }

  int colorSelected() {
    return _themeService.colorSelected;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_themeService];

  Widget getViewForIndex() {
    switch (_selectedIndex) {
      case 0:
        return TopHeadlinesView();
      case 1:
        return AllNewsView();
      default:
        return Container(
          color: Colors.yellow,
          child: Center(
            child: Text("No view for index: $_selectedIndex"),
          ),
        );
    }
  }
}
