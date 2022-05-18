import 'package:news_app_mayank/app/base_viewmodel_mixin.dart';
import 'package:news_app_mayank/enums/snackbar_type.dart';
import 'package:stacked/stacked.dart';

class AppWebViewModel extends BaseViewModel with BaseViewModelMixin {
  int _loadingPercentage = 0;

  int get loadingPercentage => _loadingPercentage;

  set loadingPercentage(int value) {
    _loadingPercentage = value;
    notifyListeners();
  }

  void showExitWebViewSnackbar() {
    snackbarService.showCustomSnackBar(
      duration: const Duration(seconds: 5),
      variant: SnackbarType.normal,
      message: 'No Back history. Press Ok to Exit.',
      mainButtonTitle: 'Ok',
      onMainButtonTapped: () {
        //Dismiss the snackbar
        navigationService.back();
        //Pop one page from the stack
        navigationService.popRepeated(1);
      },
    );
  }

  void shownoFwdHistorySnackbar() {
    snackbarService.showCustomSnackBar(
      duration: const Duration(seconds: 2),
      variant: SnackbarType.normal,
      message: 'No Forward history.',
    );
  }
}
