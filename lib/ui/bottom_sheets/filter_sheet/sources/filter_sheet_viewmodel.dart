import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;

const String getSourcesFromDbBusyObject = 'getSourcesFromDbBusyObject';
const String getSourcesFromTopHeadlinesBusyObject =
    'getSourcesFromTopHeadlinesBusyObject';

class FilterSheetViewModel extends IndexTrackingViewModel
    with BaseViewModelMixin {
  final DatabaseService _databaseService = locator<DatabaseService>();
  complete_source.Sources _onlineSources = complete_source.Sources.empty();
  List<complete_source.Source> _savedSources = [];
  final List<complete_source.Source> _selectedSources = [];

  getSourcesFromDb() async {
    _savedSources = await runBusyFuture(_databaseService.getSavedSources(),
        busyObject: getSourcesFromDbBusyObject);
  }

  List<complete_source.Source> get savedSources => _savedSources;

  List<complete_source.Source> get selectedSources => _selectedSources;

  complete_source.Sources get onlineSources => _onlineSources;

  init() {
    setIndex(0);
    getSourcesFromDb();
    getSourcesFromTopHeadlines();
  }

  void updateSelectedSource({required int index, bool? value}) {
    complete_source.Source singleSource = _savedSources.elementAt(index);

    if (value == true) {
      _selectedSources.add(singleSource);
    } else {
      _selectedSources.removeAt(index);
    }

    notifyListeners();
  }

  checkIfSelectedSourceIsInDb({required int index}) {
    return _selectedSources.contains(_savedSources.elementAt(index));
  }

  void getSourcesFromTopHeadlines() async {
    _onlineSources = await runBusyFuture(
      networkApiService.getOnlineSources(),
      busyObject: getSourcesFromTopHeadlinesBusyObject,
    );
  }

  checkIfSelectedSourceIsInOnlineSources({required int index}) {
    return _selectedSources.contains(_onlineSources.sources?.elementAt(index));
  }

  void updateSelectedSourceFromOnlineSourcesList(
      {required int index, bool? value}) {
    complete_source.Source? singleSource =
        _onlineSources.sources?.elementAt(index);

    if (singleSource != null) {
      if (value == true) {
        _selectedSources.add(singleSource);
      } else {
        _selectedSources.removeAt(index);
      }
      notifyListeners();
    }
  }
}
