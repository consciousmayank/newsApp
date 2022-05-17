import 'package:news_app_mayank/app/app.router.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:stacked/stacked.dart';

const String getNewsBusyObjectKey = 'getNewsBusyObjectKey';
const String getNextPageNewsBusyObjectKey = 'getNextPageNewsBusyObjectKey';

class NewsListViewModel extends BaseViewModel with BaseViewModelMixin {
  int _pageNumber = 1;

  set pageNumber(int value) {
    _pageNumber = value;
    getNews();
  }

  int get pageNumber => _pageNumber;
  String? _queryString;
  set queryString(String? value) {
    _queryString = value;
    getNews();
  }

  String? get queryString => _queryString;

  NewsArticles newsArticles = NewsArticles.empty();
  late final NewsListType _newsListType;
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
            page: pageNumber,
            pageSize: 20,
            query: _queryString,
          ),
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
            query: _queryString ?? 'ipl',
            searchIn: [
              SearchIn.title,
              // SearchIn.content,
              // SearchIn.description,
            ],
          ),
          busyObject: pageNumber == 1
              ? getNewsBusyObjectKey
              : getNextPageNewsBusyObjectKey,
        );
        break;
      case NewsListType.mySavedSources:
        apiResponse = await runBusyFuture(
          networkApiService.getEverything(
            page: pageNumber,
            pageSize: 20,
            query: _queryString ?? 'ipl',
            searchIn: [
              SearchIn.title,
              // SearchIn.content,
              // SearchIn.description,
            ],
          ),
          busyObject: pageNumber == 1
              ? getNewsBusyObjectKey
              : getNextPageNewsBusyObjectKey,
        );
        break;
      case NewsListType.bookmarkedArticles:
        apiResponse = await runBusyFuture(
          networkApiService.getEverything(
            page: pageNumber,
            pageSize: 20,
            query: _queryString ?? 'ipl',
            searchIn: [
              SearchIn.title,
              // SearchIn.content,
              // SearchIn.description,
            ],
          ),
          busyObject: pageNumber == 1
              ? getNewsBusyObjectKey
              : getNextPageNewsBusyObjectKey,
        );
        break;
    }

    if (pageNumber == 1) {
      newsArticles = apiResponse;
    } else if (apiResponse.articles != null) {
      newsArticles.articles?.addAll(apiResponse.articles!);
    }
  }

  void setBookMarked({required int index}) {
    Article singleArticle =
        newsArticles.articles?.elementAt(index) ?? Article.empty();

    if (singleArticle.title != null) {
      singleArticle =
          singleArticle.copyWith(isBookmarked: !singleArticle.isBookmarked);
      newsArticles.articles?.removeAt(index);
      newsArticles.articles?.insert(index, singleArticle);
      notifyListeners();
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

  void showFiltersBottomSheet() {}

  int getListLength() {
    return newsArticles.articles != null && newsArticles.articles!.isNotEmpty
        ? newsArticles.articles!.length
        : 0;
  }
}
