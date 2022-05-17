import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/enums/bottom_sheet_type.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/filter_sheet_view.dart';
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
    BottomSheetType.filter: (context, sheetRequest, completer) => FilterSheet(
          completer: completer,
          request: sheetRequest,
        ),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
