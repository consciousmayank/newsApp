import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/app/app.router.dart';
import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:news_app_mayank/enums/snackbar_type.dart';
import 'package:news_app_mayank/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;

const String getNewsBusyObjectKey = 'getNewsBusyObjectKey';
const String getNextPageNewsBusyObjectKey = 'getNextPageNewsBusyObjectKey';

class NewsListViewModel extends BaseViewModel with BaseViewModelMixin {
  final List<complete_source.Source> _sources = [];

  final DatabaseService _databaseService = locator<DatabaseService>();
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

  void showFiltersBottomSheet() {}

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

  checkIfSourceExistsInDb({required String sourceName}) async {
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
          snackbarService.showCustomSnackBar(
            message: 'Source saved',
            variant: SnackbarType.normal,
          );

          updateArticle(
            selectedArticleIndex: selectedArticleIndex,
            value: true,
          );
        }
      } else {
        int? indexOfDeletedSource = await _databaseService.deleteSavedSources(
            name: sourceFromDb.name ?? '');

        if (indexOfDeletedSource != null && indexOfDeletedSource > 0) {
          snackbarService.showCustomSnackBar(
            message: 'Source Removed',
            variant: SnackbarType.normal,
          );
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
}
