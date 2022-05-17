import 'package:flutter_test/flutter_test.dart';
import 'package:test_ground/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('NewsListViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

