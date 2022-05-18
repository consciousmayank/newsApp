import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/ui/views/news_list/news_list_view.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends ReactiveViewModel {
  int _selectedIndex = 0;
  final MaterialThemeServiceService _themeService =
      locator<MaterialThemeServiceService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_themeService];

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
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

  Widget getViewForIndex() {
    switch (_selectedIndex) {
      case 0:
        return const NewsListView(
          key: Key('0'),
          newsListType: NewsListType.topHeadlines,
        );
      case 1:
        return const NewsListView(
          key: Key('1'),
          newsListType: NewsListType.everything,
        );
      default:
        return const NewsListView(
          key: Key('2'),
          newsListType: NewsListType.mySavedSources,
        );
    }
  }
}
