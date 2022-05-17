import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_mayank/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:news_app_mayank/services/material_app_service_service.dart';
import 'package:news_app_mayank/services/material_theme_service_service.dart';
import 'package:news_app_mayank/services/dio_client_service.dart';
import 'package:news_app_mayank/services/network_api_service.dart';
import 'package:news_app_mayank/services/database_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
  MockSpec<BottomSheetService>(returnNullOnMissingStub: true),
  MockSpec<DialogService>(returnNullOnMissingStub: true),
  MockSpec<MaterialAppServiceService>(returnNullOnMissingStub: true),
  MockSpec<MaterialThemeServiceService>(returnNullOnMissingStub: true),
  MockSpec<DioClientService>(returnNullOnMissingStub: true),
  MockSpec<NetworkApiService>(returnNullOnMissingStub: true),
MockSpec<DatabaseService>(returnNullOnMissingStub: true),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterMaterialAppServiceService();
  getAndRegisterMaterialThemeServiceService();
  getAndRegisterDioClientService();
  getAndRegisterNetworkApiServiceService();
getAndRegisterDatabaseService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockMaterialAppServiceService getAndRegisterMaterialAppServiceService() {
  _removeRegistrationIfExists<MaterialAppServiceService>();
  final service = MockMaterialAppServiceService();
  locator.registerSingleton<MaterialAppServiceService>(service);
  return service;
}

MockMaterialThemeServiceService getAndRegisterMaterialThemeServiceService() {
  _removeRegistrationIfExists<MaterialThemeServiceService>();
  final service = MockMaterialThemeServiceService();
  locator.registerSingleton<MaterialThemeServiceService>(service);
  return service;
}

MockDioClientService getAndRegisterDioClientService() {
  _removeRegistrationIfExists<DioClientService>();
  final service = MockDioClientService();
  locator.registerSingleton<DioClientService>(service);
  return service;
}

MockNetworkApiService getAndRegisterNetworkApiServiceService() {
  _removeRegistrationIfExists<NetworkApiService>();
  final service = MockNetworkApiService();
  locator.registerSingleton<NetworkApiService>(service);
  return service;
}
MockDatabaseService getAndRegisterDatabaseService() { 
_removeRegistrationIfExists<DatabaseService>(); 
final service = MockDatabaseService(); 
locator.registerSingleton<DatabaseService>(service); 
return service; 
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
