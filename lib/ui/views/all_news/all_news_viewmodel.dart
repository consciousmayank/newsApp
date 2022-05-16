import 'package:news_app_mayank/app/app.router.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:stacked/stacked.dart';

const String getAllNewsBusyObjectKey = 'getAllNewsBusyObjectKey';
const String getNextPageAllNewsBusyObjectKey =
    'getNextPageAllNewsBusyObjectKey';

class AllNewsViewModel extends BaseViewModel with BaseViewModelMixin {
  int _pageNumber = 1;

  set pageNumber(int value) {
    _pageNumber = value;
    getAllNews();
  }

  int get pageNumber => _pageNumber;
  String? _queryString;
  set queryString(String? value) {
    _queryString = value;
    getAllNews();
  }

  String? get queryString => _queryString;

  NewsArticles allNews = NewsArticles.empty();

  void getAllNews() async {
    NewsArticles apiResponse = await runBusyFuture(
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
          ? getAllNewsBusyObjectKey
          : getNextPageAllNewsBusyObjectKey,
    );

    if (pageNumber == 1) {
      allNews = apiResponse;
    } else if (apiResponse.articles != null) {
      allNews.articles?.addAll(apiResponse.articles!);
    }
  }

  void setBookMarked({required int index}) {
    Article singleArticle =
        allNews.articles?.elementAt(index) ?? Article.empty();

    if (singleArticle.title != null) {
      singleArticle =
          singleArticle.copyWith(isBookmarked: !singleArticle.isBookmarked);
      allNews.articles?.removeAt(index);
      allNews.articles?.insert(index, singleArticle);
      notifyListeners();
    }
  }

  openArticle(int index) {
    if (allNews.articles != null && allNews.articles!.isNotEmpty) {
      navigationService.navigateTo(
        Routes.appWebView,
        arguments: AppWebViewArguments(
          urlToLoad: allNews.articles!.elementAt(index).url ?? '',
          source: allNews.articles!.elementAt(index).source,
        ),
      );
    }
  }

  void showFiltersBottomSheet() {}

  int getListLength() {
    return allNews.articles != null && allNews.articles!.isNotEmpty
        ? allNews.articles!.length
        : 0;
  }
}
