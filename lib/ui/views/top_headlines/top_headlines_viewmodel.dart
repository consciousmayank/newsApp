import 'package:news_app_mayank/app/app.router.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:stacked/stacked.dart';

const String getTopHeadlinesBusyObjectKey = 'getTopHeadlinesBusyObjectKey';
const String getNextTopHeadlinesBusyObjectKey =
    'getNextTopHeadlinesBusyObjectKey';

class TopHeadlinesViewModel extends BaseViewModel with BaseViewModelMixin {
  int _pageNumber = 1;

  set pageNumber(int value) {
    _pageNumber = value;
    getTopHeadlines();
  }

  int get pageNumber => _pageNumber;

  String? _queryString;
  set queryString(String? value) {
    _queryString = value;
    getTopHeadlines();
  }

  String? get queryString => _queryString;

  NewsArticles topHeadlines = NewsArticles.empty();

  void getTopHeadlines() async {
    NewsArticles apiResponse = await runBusyFuture(
      networkApiService.getTopHeadlines(
        page: pageNumber,
        pageSize: 20,
        query: _queryString,
      ),
      busyObject: pageNumber == 1
          ? getTopHeadlinesBusyObjectKey
          : getNextTopHeadlinesBusyObjectKey,
    );

    if (pageNumber == 1) {
      topHeadlines = apiResponse;
    } else if (apiResponse.articles != null) {
      topHeadlines.articles?.addAll(apiResponse.articles!);
    }
  }

  void setBookMarked({required int index}) {
    Article singleArticle =
        topHeadlines.articles?.elementAt(index) ?? Article.empty();

    if (singleArticle.title != null) {
      singleArticle =
          singleArticle.copyWith(isBookmarked: !singleArticle.isBookmarked);
      topHeadlines.articles?.removeAt(index);
      topHeadlines.articles?.insert(index, singleArticle);
      notifyListeners();
    }
  }

  openArticle(int index) {
    if (topHeadlines.articles != null && topHeadlines.articles!.isNotEmpty) {
      navigationService.navigateTo(
        Routes.appWebView,
        arguments: AppWebViewArguments(
          urlToLoad: topHeadlines.articles!.elementAt(index).url ?? '',
          source: topHeadlines.articles!.elementAt(index).source,
        ),
      );
    }
  }

  void showFiltersBottomSheet() {}

  int getListLength() {
    return topHeadlines.articles != null && topHeadlines.articles!.isNotEmpty
        ? topHeadlines.articles!.length
        : 0;
  }
}
