// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/database_service.dart';
import '../services/dio_client_service.dart';
import '../services/material_app_service_service.dart';
import '../services/material_theme_service_service.dart';
import '../services/network_api_service.dart';

final locator = StackedLocator.instance;

Future setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  final databaseService = await DatabaseService.getInstance();
  locator.registerSingleton(databaseService);

  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => MaterialThemeServiceService());
  locator.registerLazySingleton(() => MaterialAppServiceService());
  locator.registerLazySingleton(() => DioClientService());
  locator.registerLazySingleton(() => NetworkApiService());
}
