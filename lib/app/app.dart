import 'package:news_app_mayank/services/database_service.dart';
import 'package:news_app_mayank/services/dio_client_service.dart';
import 'package:news_app_mayank/services/material_app_service_service.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/services/network_api_service.dart';
import 'package:news_app_mayank/ui/views/dashboard/dashboard_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:news_app_mayank/ui/views/startup/startup_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:news_app_mayank/ui/views/app_web/app_web_view.dart';
import 'package:news_app_mayank/ui/views/news_list/news_list_view.dart';
import 'package:news_app_mayank/ui/views/my_feed/my_feed_view.dart';
// @stacked-import

@StackedApp(
    routes: [
      MaterialRoute(page: StartupView),
      MaterialRoute(page: DashBoardView),
      MaterialRoute(page: AppWebView),
      MaterialRoute(page: NewsListView),
MaterialRoute(page: MyFeedView),
// @stacked-route
    ],
    logger: StackedLogger(),
    dependencies: [
      Presolve(
        classType: DatabaseService,
        presolveUsing: DatabaseService.getInstance,
      ),
      LazySingleton(
        classType: NavigationService,
      ),
      LazySingleton(
        classType: DialogService,
      ),
      LazySingleton(
        classType: BottomSheetService,
      ),
      LazySingleton(
        classType: SnackbarService,
      ),
      LazySingleton(
        classType: MaterialThemeServiceService,
      ),
      LazySingleton(
        classType: MaterialAppServiceService,
      ),
      LazySingleton(
        classType: DioClientService,
      ),
      LazySingleton(
        classType: NetworkApiService,
      ),
    ])
class App {}

//flutter pub run build_runner build --delete-conflicting-outputs
