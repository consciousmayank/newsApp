// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../data_classes/new_articles.dart';
import '../enums/news_list_type.dart';
import '../ui/views/app_web/app_web_view.dart';
import '../ui/views/dashboard/dashboard_view.dart';
import '../ui/views/news_list/news_list_view.dart';
import '../ui/views/startup/startup_view.dart';

class Routes {
  static const String startupView = '/startup-view';
  static const String dashBoardView = '/dash-board-view';
  static const String appWebView = '/app-web-view';
  static const String newsListView = '/news-list-view';
  static const all = <String>{
    startupView,
    dashBoardView,
    appWebView,
    newsListView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.dashBoardView, page: DashBoardView),
    RouteDef(Routes.appWebView, page: AppWebView),
    RouteDef(Routes.newsListView, page: NewsListView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartupView(),
        settings: data,
      );
    },
    DashBoardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DashBoardView(),
        settings: data,
      );
    },
    AppWebView: (data) {
      var args = data.getArgs<AppWebViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AppWebView(
          key: args.key,
          urlToLoad: args.urlToLoad,
          source: args.source,
        ),
        settings: data,
      );
    },
    NewsListView: (data) {
      var args = data.getArgs<NewsListViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsListView(
          key: args.key,
          newsListType: args.newsListType,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AppWebView arguments holder class
class AppWebViewArguments {
  final Key? key;
  final String urlToLoad;
  final Source? source;
  AppWebViewArguments(
      {this.key, required this.urlToLoad, required this.source});
}

/// NewsListView arguments holder class
class NewsListViewArguments {
  final Key? key;
  final NewsListType newsListType;
  NewsListViewArguments({this.key, required this.newsListType});
}
