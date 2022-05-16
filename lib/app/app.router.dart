// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../data_classes/new_articles.dart';
import '../ui/views/all_news/all_news_view.dart';
import '../ui/views/app_web/app_web_view.dart';
import '../ui/views/dashboard/dashboard_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/top_headlines/top_headlines_view.dart';

class Routes {
  static const String startupView = '/startup-view';
  static const String dashBoardView = '/dash-board-view';
  static const String topHeadlinesView = '/top-headlines-view';
  static const String allNewsView = '/all-news-view';
  static const String appWebView = '/app-web-view';
  static const all = <String>{
    startupView,
    dashBoardView,
    topHeadlinesView,
    allNewsView,
    appWebView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.dashBoardView, page: DashBoardView),
    RouteDef(Routes.topHeadlinesView, page: TopHeadlinesView),
    RouteDef(Routes.allNewsView, page: AllNewsView),
    RouteDef(Routes.appWebView, page: AppWebView),
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
    TopHeadlinesView: (data) {
      var args = data.getArgs<TopHeadlinesViewArguments>(
        orElse: () => TopHeadlinesViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => TopHeadlinesView(key: args.key),
        settings: data,
      );
    },
    AllNewsView: (data) {
      var args = data.getArgs<AllNewsViewArguments>(
        orElse: () => AllNewsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AllNewsView(key: args.key),
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
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// TopHeadlinesView arguments holder class
class TopHeadlinesViewArguments {
  final Key? key;
  TopHeadlinesViewArguments({this.key});
}

/// AllNewsView arguments holder class
class AllNewsViewArguments {
  final Key? key;
  AllNewsViewArguments({this.key});
}

/// AppWebView arguments holder class
class AppWebViewArguments {
  final Key? key;
  final String urlToLoad;
  final Source? source;
  AppWebViewArguments(
      {this.key, required this.urlToLoad, required this.source});
}
