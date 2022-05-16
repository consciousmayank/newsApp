import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_mayank/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('NetworkApiServiceServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
