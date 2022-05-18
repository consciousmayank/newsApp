import 'package:dio/dio.dart';
import 'package:news_app_mayank/app/api_endpoints.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/enums/category.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:news_app_mayank/enums/snackbar_type.dart';
import 'package:news_app_mayank/enums/sort_by.dart';
import 'package:news_app_mayank/services/dio_client_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;

abstract class AbstractNetworkApiService {
  ///Get everything from the network
  Future<NewsArticles> getEverything({
    required int page,
    required int pageSize,
    String? query,
    List<String> sources,
    SortBy sortBy,
    List<SearchIn> searchIn,
  });

  ///Get top headlines from the network
  Future<NewsArticles> getTopHeadlines({
    Category category,
    List<String> sources,
    required int page,
    required int pageSize,
    String? query,
    required String country,
  });

  Future<complete_source.Sources> getOnlineSources();
}

class NetworkApiService implements AbstractNetworkApiService {
  final DioClientService _dioClientService = locator<DioClientService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  @override
  Future<NewsArticles> getEverything({
    required int page,
    required int pageSize,
    String? query,
    List<String> sources = const [],
    SortBy sortBy = SortBy.publishedAt,
    List<SearchIn> searchIn = const [],
  }) async {
    NewsArticles newsArticles = NewsArticles.empty();

    Map<String, String> queryParameters = {};

    queryParameters['page'] = page.toString();
    queryParameters['pageSize'] = pageSize.toString();
    queryParameters['sortBy'] = sortBy.name;

    if (sources.isNotEmpty) {
      queryParameters['sources'] = sources.join(',');
    }

    if (searchIn.isNotEmpty) {
      queryParameters['searchIn'] =
          searchIn.map((e) => e.name).toList().join(',');
    }

    if (query != null && query.isNotEmpty) {
      queryParameters['q'] = query;
    }
    try {
      final Response response = await _dioClientService.dio.get(
        everythingApiEndpoint,
        queryParameters: queryParameters,
      );

      newsArticles = NewsArticles.fromMap(response.data);
    } on DioError catch (e) {
      _snackbarService.showCustomSnackBar(
        message: e.response?.data['message'],
        title: 'Error',
        variant: SnackbarType.error,
      );
    }

    return newsArticles;
  }

  @override
  Future<NewsArticles> getTopHeadlines({
    Category category = Category.all,
    List<String> sources = const [],
    required int page,
    required int pageSize,
    String? query,
    required String country,
  }) async {
    NewsArticles newsArticles = NewsArticles.empty();

    Map<String, dynamic> queryParameters = {};

    queryParameters['page'] = page.toString();
    queryParameters['pageSize'] = pageSize.toString();

    // if (sources.isEmpty) {
    queryParameters['country'] = country;
    // }

    if (category != Category.all) {
      queryParameters['category'] = category.name;
    }

    if (sources.isNotEmpty) {
      queryParameters['sources'] = sources.join(',');
    }

    if (query != null && query.isNotEmpty) {
      queryParameters['q'] = query;
    }

    try {
      final Response response = await _dioClientService.dio.get(
        topHeadlinesApiEndpoint,
        queryParameters: queryParameters,
      );
      newsArticles = NewsArticles.fromMap(response.data);
    } on DioError catch (e) {
      _snackbarService.showCustomSnackBar(
        message: e.response?.data['message'],
        title: 'Error',
        variant: SnackbarType.error,
      );
    }

    return newsArticles;
  }

  @override
  Future<complete_source.Sources> getOnlineSources() async {
    complete_source.Sources sources = complete_source.Sources.empty();

    try {
      final Response response = await _dioClientService.dio.get(
        sourcesApiEndpoint,
        queryParameters: {
          'language': "en",
          // 'country': "in",
        },
      );

      sources = complete_source.Sources.fromMap(response.data);
    } on DioError catch (e) {
      _snackbarService.showCustomSnackBar(
        message: e.response?.data['message'],
        title: 'Error',
        variant: SnackbarType.error,
      );
    }

    return sources;
  }
}
