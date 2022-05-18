import 'dart:io';

import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/app/app.router.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;
import 'package:news_app_mayank/enums/bottom_sheet_type.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:news_app_mayank/enums/sort_by.dart';
import 'package:news_app_mayank/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:news_app_mayank/enums/category.dart' as enum_category;

const String getNewsBusyObjectKey = 'getNewsBusyObjectKey';
const String getNextPageNewsBusyObjectKey = 'getNextPageNewsBusyObjectKey';

class NewsListViewModel extends BaseViewModel with BaseViewModelMixin {
  List<String> allNewsfilterOptions = [
    'Select Source/s',
    'Select a Country',
    'Select searchIn',
    'Sort By'
  ];

  NewsArticles newsArticles = NewsArticles.empty();
  enum_category.Category selectedCategory = enum_category.Category.all;
  String selectedCountry = 'in';
  List<String> topHeadlinesfilterOptions = [
    'Select a Category',
    'Select Source/s',
    'Select a Country'
  ];

  final DatabaseService _databaseService = locator<DatabaseService>();
  late final NewsListType _newsListType;
  int _pageNumber = 1;
  String? _queryString;
  String _selectedFilterOption = '';
  List<SearchIn> _selectedSearchIns = [];
  SortBy _selectedSortBy = SortBy.publishedAt;
  List<complete_source.Source> _selectedSources = [];

  set pageNumber(int value) {
    _pageNumber = value;
    getNews();
  }

  int get pageNumber => _pageNumber;

  set queryString(String? value) {
    _queryString = value;
    getNews();
  }

  String? get queryString => _queryString;

  init({required newsListType}) {
    _newsListType = newsListType;

    getNews();
  }

  void getNews() async {
    NewsArticles apiResponse;

    switch (_newsListType) {
      case NewsListType.topHeadlines:
        apiResponse = await runBusyFuture(
          networkApiService.getTopHeadlines(
              country: selectedCountry,
              category: selectedCategory,
              page: pageNumber,
              pageSize: 20,
              query: _queryString,
              sources: _selectedSources.map((e) => e.id ?? '').toList()),
          busyObject: pageNumber == 1
              ? getNewsBusyObjectKey
              : getNextPageNewsBusyObjectKey,
        );

        break;
      case NewsListType.everything:
        apiResponse = await runBusyFuture(
          networkApiService.getEverything(
            page: pageNumber,
            pageSize: 20,
            query: _selectedSources.isEmpty ? _queryString ?? 'ipl' : null,
            searchIn: _selectedSearchIns,
            sortBy: _selectedSortBy,
            sources: _selectedSources.map((e) => e.id ?? '').toList(),
          ),
          busyObject: pageNumber == 1
              ? getNewsBusyObjectKey
              : getNextPageNewsBusyObjectKey,
        );

        break;
      case NewsListType.mySavedSources:
        List<Article> articleList = await runBusyFuture(
          _databaseService.getSavedArticles(),
          busyObject: getNewsBusyObjectKey,
        );

        apiResponse = NewsArticles(
          status: 'ok',
          articles: articleList,
          totalResults: articleList.length,
        );
        break;
      case NewsListType.bookmarkedArticles:
        List<Article> articleList = await runBusyFuture(
          _databaseService.getSavedArticles(),
          busyObject: getNewsBusyObjectKey,
        );

        apiResponse = NewsArticles(
          status: 'ok',
          articles: articleList,
          totalResults: articleList.length,
        );
        break;
    }

    apiResponse = await checkifArticleExistsInDb(apiResponse: apiResponse);

    if (pageNumber == 1) {
      newsArticles = apiResponse;
    } else if (apiResponse.articles != null) {
      newsArticles.articles?.addAll(apiResponse.articles!);
    }
    notifyListeners();
  }

  void setBookMarked({required int index}) async {
    if (newsArticles.articles![index].isBookmarked) {
      // Already saved in Db. remove from Db, and update UI, if NewsListType == mySavedSources
      int? indexOfDeletedArticle = await _databaseService.deleteSavedArticle(
        title: newsArticles.articles![index].title ?? '',
      );

      if (indexOfDeletedArticle != null && indexOfDeletedArticle > 0) {
        Article singleArticle =
            newsArticles.articles?.elementAt(index) ?? Article.empty();

        if (singleArticle.title != null) {
          singleArticle = singleArticle.copyWith(isBookmarked: false);
          newsArticles.articles?.removeAt(index);
          newsArticles.articles?.insert(index, singleArticle);
          notifyListeners();
        }
      }
    } else {
      // Not saved in Db. Save in Db, and update UI, if NewsListType == mySavedSources

      int? indexOfInsertedArticle =
          await _databaseService.insertArticle(newsArticles.articles![index]);

      if (indexOfInsertedArticle != null && indexOfInsertedArticle > 0) {
        Article singleArticle =
            newsArticles.articles?.elementAt(index) ?? Article.empty();

        if (singleArticle.title != null) {
          singleArticle = singleArticle.copyWith(isBookmarked: true);
          newsArticles.articles?.removeAt(index);
          newsArticles.articles?.insert(index, singleArticle);
          notifyListeners();
        }
      }
    }

    if (_newsListType == NewsListType.mySavedSources) {
      getNews();
    }
  }

  openArticle(int index) {
    if (newsArticles.articles != null && newsArticles.articles!.isNotEmpty) {
      navigationService.navigateTo(
        Routes.appWebView,
        arguments: AppWebViewArguments(
          urlToLoad: newsArticles.articles!.elementAt(index).url ?? '',
          source: newsArticles.articles!.elementAt(index).source,
        ),
      );
    }
  }

  Future<void> showFiltersBottomSheet() async {
    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sourcesFilter,
      title: 'Filter By Sources',
      description:
          'Select the sources whose news you want to see. You can select multiple sources. You can choose from the list of all the sources, or from the list of your saved sources.',
      isScrollControlled: true,
    );

    if (response != null && response.confirmed) {
      selectedCategory = enum_category.Category.all;
      _selectedSources = response.data as List<complete_source.Source>;
      getNews();
    }
  }

  int getListLength() {
    return newsArticles.articles != null && newsArticles.articles!.isNotEmpty
        ? newsArticles.articles!.length
        : 0;
  }

  Future<NewsArticles> checkifArticleExistsInDb(
      {required NewsArticles apiResponse}) async {
    List<Article> articleList = await _databaseService.getSavedArticles();

    if (articleList.isNotEmpty) {
      for (var articleFromDb in articleList) {
        apiResponse.articles?.forEach((articleFromApi) {
          if (articleFromApi.title == articleFromDb.title) {
            int? indexOfArticle = apiResponse.articles?.indexOf(articleFromApi);
            articleFromApi = articleFromApi.copyWith(
              isBookmarked: true,
            );

            if (indexOfArticle != null && indexOfArticle >= 0) {
              apiResponse.articles?.removeAt(indexOfArticle);
              apiResponse.articles?.insert(indexOfArticle, articleFromApi);
            }
          }
        });
      }
    }

    return apiResponse;
  }

  Future<List<complete_source.Source>> getSourcesFromDb() async {
    return await _databaseService.getSavedSources();
  }

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

  void saveSource({
    Source? source,
    required int selectedArticleIndex,
  }) async {
    if (source != null) {
      complete_source.Source sourceFromDb =
          await checkIfSourceExistsInDb(sourceName: source.name ?? '');

      if (sourceFromDb.id == null) {
        int? indexOfInsertedSource = await _databaseService.insertSource(
          complete_source.Source(
            id: source.id,
            name: source.name,
            description: '',
            url: '',
            category: '',
            language: '',
            country: '',
          ),
        );
        if (indexOfInsertedSource != null && indexOfInsertedSource > 0) {
          updateArticle(
            selectedArticleIndex: selectedArticleIndex,
            value: true,
          );
        }
      } else {
        int? indexOfDeletedSource = await _databaseService.deleteSavedSources(
            name: sourceFromDb.name ?? '');

        if (indexOfDeletedSource != null && indexOfDeletedSource > 0) {
          // snackbarService.showCustomSnackBar(
          //   message: 'Source Removed',
          //   variant: SnackbarType.normal,
          // );
          updateArticle(
            selectedArticleIndex: selectedArticleIndex,
            value: false,
          );
        }
      }
    }
  }

  void updateArticle({required int selectedArticleIndex, required bool value}) {
    Article singleArticle =
        newsArticles.articles?.elementAt(selectedArticleIndex) ??
            Article.empty();

    if (singleArticle.title != null) {
      singleArticle = singleArticle.copyWith(
        source: singleArticle.source?.copyWith(
          isSaved: value,
        ),
      );
      newsArticles.articles?.removeAt(selectedArticleIndex);
      newsArticles.articles?.insert(selectedArticleIndex, singleArticle);
      notifyListeners();
    }
  }

  void deleteSource({required int index}) {
    dialogService
        .showConfirmationDialog(
      barrierDismissible: true,
      cancelTitle: 'Cancel',
      confirmationTitle: 'Yes',
      description: 'Are you sure you want to delete this source?',
      title: 'Delete Source',
      dialogPlatform: Platform.isAndroid
          ? DialogPlatform.Material
          : DialogPlatform.Cupertino,
    )
        .then((value) {
      if (value != null && value.confirmed) {
        saveSource(
          source: newsArticles.articles?.elementAt(index).source,
          selectedArticleIndex: index,
        );
        notifyListeners();
      }
    });
  }

  String get selectedFilterOption => _selectedFilterOption.isEmpty
      ? _newsListType == NewsListType.topHeadlines
          ? topHeadlinesfilterOptions.first
          : allNewsfilterOptions.first
      : _selectedFilterOption;

  set selectedFilterOption(String value) {
    _selectedFilterOption = value;
    notifyListeners();
  }

  Future<void> showCategoryFiltersBottomSheet() async {
    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.categoriesFilter,
      title: 'Select a Category',
      description:
          'Select the category whose news you want to see. You can select only one of the provided categories.',
      isScrollControlled: false,
    );

    if (response != null && response.confirmed) {
      _selectedSources.clear();
      selectedCategory = response.data as enum_category.Category;
      getNews();
    }
  }

  Future<void> showCountryFiltersBottomSheet() async {
    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.countriesFilter,
      title: 'Select a Country',
      description:
          'Select the country whose news you want to see. You can select only one of the provided countries.',
      isScrollControlled: false,
    );

    if (response != null && response.confirmed) {
      selectedCountry = response.data as String;
      selectedCountry = '';
      _selectedSources.clear();
      selectedCategory = enum_category.Category.all;
      getNews();
    }
  }

  Future<void> showSearchInBottomSheet() async {
    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.searchinFilter,
      title: 'Select where to search',
      description:
          'Select the fields to restrict your search to. You can select multiple options',
      isScrollControlled: false,
    );

    if (response != null && response.confirmed) {
      _selectedSearchIns = response.data as List<SearchIn>;
      getNews();
    }
  }

  Future<void> showSortByInBottomSheet() async {
    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sortByFilter,
      title: 'Select how the resuts should be sorted',
      description: 'You can select only one option at a time',
      isScrollControlled: false,
    );

    if (response != null && response.confirmed) {
      _selectedSortBy = response.data as SortBy;
      getNews();
    }
  }

  void handleTopHeadlinesFilterOptionSelection(int value) {
    selectedFilterOption = topHeadlinesfilterOptions.elementAt(value);
    switch (value) {
      case 0:
        showCategoryFiltersBottomSheet();
        break;

      case 1:
        showFiltersBottomSheet();
        break;
      case 2:
        showCountryFiltersBottomSheet();
        break;
    }
  }

  void handleAllNewsFilterOptionSelection(int value) {
    selectedFilterOption = allNewsfilterOptions.elementAt(value);
    switch (value) {
      case 0:
        showFiltersBottomSheet();
        break;

      case 1:
        showCountryFiltersBottomSheet();
        break;

      case 2:
        showSearchInBottomSheet();
        break;
      case 3:
        showSortByInBottomSheet();
        break;
    }
  }
}
