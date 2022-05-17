import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_mayank/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  // DashboardViewModel _getModel() => DashboardViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    group('incrementCounter -', () {
      test('When called once should return  Counter is: 1', () {});
    });

    group('showBottomSheet -', () {
      test('When called, should show custom bottom sheet using notice variant',
          () {
        // final bottomSheetService = getAndRegisterBottomSheetService();

        // final model = _getModel();
        // model.showBottomSheet();
        // verify(bottomSheetService.showCustomSheet(
        //   variant: BottomSheetType.notice,
        //   title: ksHomeBottomSheetTitle,
        //   description: ksHomeBottomSheetDescription,
        // ));
      });
    });
  });
}
