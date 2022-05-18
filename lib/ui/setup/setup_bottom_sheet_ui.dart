import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/bottom_sheet_type.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/category_filter_sheet.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/country_filter_sheet.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/searchin_filter_sheet.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/sortyby_filter_sheet.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/sources/filter_sheet_view.dart';
import 'package:news_app_mayank/ui/bottom_sheets/notice_sheet/notice_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final Map<
      dynamic,
      Widget Function(BuildContext, SheetRequest<dynamic>,
          void Function(SheetResponse<dynamic>))> builders = {
    BottomSheetType.notice: (context, sheetRequest, completer) => NoticeSheet(
          completer: completer,
          request: sheetRequest,
        ),
    BottomSheetType.sourcesFilter: (context, sheetRequest, completer) =>
        FilterSheet(
          completer: completer,
          request: sheetRequest,
        ),
    BottomSheetType.categoriesFilter: (context, sheetRequest, completer) =>
        CategoryFilterSheet(
          completer: completer,
          request: sheetRequest,
        ),
    BottomSheetType.countriesFilter: (context, sheetRequest, completer) =>
        CountryFilterSheet(
          completer: completer,
          request: sheetRequest,
        ),
    BottomSheetType.searchinFilter: (context, sheetRequest, completer) =>
        SearchInFilterList(
          completer: completer,
          request: sheetRequest,
        ),
    BottomSheetType.sortByFilter: (context, sheetRequest, completer) =>
        SortByFilterList(
          completer: completer,
          request: sheetRequest,
        ),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
