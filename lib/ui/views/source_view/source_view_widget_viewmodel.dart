import 'package:flutter/material.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/services/database_service.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:stacked/stacked.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;

class SourceViewWidgetModel extends ReactiveViewModel with BaseViewModelMixin {
  late complete_source.Source source;

  final DatabaseService _databaseService = locator<DatabaseService>();
  final MaterialThemeServiceService _materialThemeService =
      locator<MaterialThemeServiceService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_materialThemeService];

  Future<List<complete_source.Source>> getSourcesFromDb() async {
    return await _databaseService.getSavedSources();
  }

  Color get selectedColor => _materialThemeService.colorOptions.elementAt(
        _materialThemeService.colorSelected,
      );

  Future checkIfSourceExistsInDb({required String sourceName}) async {
    List<complete_source.Source> savedSources = await getSourcesFromDb();
    return savedSources.firstWhere(
      (element) => element.name == sourceName,
      orElse: () => complete_source.Source(
        id: null,
        name: null,
        description: null,
        url: null,
        category: null,
        language: null,
        country: null,
      ),
    );
  }

  isSourceSaved({required String sourceName}) async {
    setBusy(true);

    source = await checkIfSourceExistsInDb(sourceName: sourceName);

    setBusy(false);
    notifyListeners();
  }

  void setSourceSelected({required bool value}) {
    source = source.copyWith(isSaved: value);
    notifyListeners();
  }
}
