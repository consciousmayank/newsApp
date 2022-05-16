import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MaterialThemeServiceService with ReactiveServiceMixin {
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];
  final List<String> _colorText = <String>[
    "Blue",
    "Green",
    "Red",
  ];

  final ReactiveValue<bool> _useMaterial3 = ReactiveValue<bool>(true);
  final ReactiveValue<bool> _useLightMode = ReactiveValue<bool>(true);
  final ReactiveValue<int> _colorSelected = ReactiveValue<int>(2);
  // final ReactiveValue<int> _screenIndex = ReactiveValue<int>(0);

  late ReactiveValue<ThemeData> _themeData;

  MaterialThemeServiceService() {
    _themeData = ReactiveValue(
        updateThemes(_colorSelected.value, true, _useLightMode.value));
    listenToReactiveValues(
      [_themeData, _colorSelected, _useLightMode, _colorOptions],
    );
  }

  get useLightMode => _useLightMode.value;

  int get colorSelected => _colorSelected.value;

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: colorOptions[_colorSelected.value],
        useMaterial3: true,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  void handleBrightnessChange() {
    _useLightMode.value = !(_useLightMode.value);
    _themeData.value = updateThemes(
        _colorSelected.value, _useMaterial3.value, _useLightMode.value);
  }

  void handleColorSelect(int value) {
    _colorSelected.value = value;
    _themeData.value = updateThemes(
        _colorSelected.value, _useMaterial3.value, _useLightMode.value);
  }

  ThemeData get themeData => _themeData.value;
  List<Color> get colorOptions => _colorOptions;
  List<String> get colorText => _colorText;
}
