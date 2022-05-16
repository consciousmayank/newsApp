import 'package:news_app_mayank/app/app.locator.dart';
import 'package:news_app_mayank/services/network_api_service.dart';
import 'package:stacked_services/stacked_services.dart';

class BaseViewModelMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NetworkApiService _networkApiService = locator<NetworkApiService>();

  NavigationService get navigationService => _navigationService;
  DialogService get dialogService => _dialogService;
  SnackbarService get snackbarService => _snackbarService;
  NetworkApiService get networkApiService => _networkApiService;
}
