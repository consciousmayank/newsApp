import 'dart:async';

import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:stacked/stacked.dart';

class MaterialAppServiceService with ReactiveServiceMixin {
  StreamSubscription? subscription;
  final ReactiveValue<bool> _connected = ReactiveValue<bool>(true);
  MaterialAppServiceService() {
    SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
      ..setLookUpAddress(
          'google.co.in'); //Optional method to pass the lookup string
    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      _connected.value = connected;
    });

    listenToReactiveValues(
      [
        _connected,
      ],
    );
  }

  bool get isConnected => _connected.value;
}
