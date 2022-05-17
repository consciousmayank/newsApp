import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/bottom_sheet_type.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/ui/common/app_strings.dart';
import 'package:news_app_mayank/ui/views/my_feed/my_feed_view.dart';
import 'package:news_app_mayank/ui/views/news_list/news_list_view.dart';
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
        return const MyFeedView(
          key: Key('2'),
        );
    }
  }
}
