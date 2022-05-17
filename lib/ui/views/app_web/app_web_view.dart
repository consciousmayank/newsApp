import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/widgets/disabled_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app_web_viewmodel.dart';

class AppWebView extends StatefulWidget {
  final String urlToLoad;
  final Source? source;
  const AppWebView({
    Key? key,
    required this.urlToLoad,
    required this.source,
  }) : super(key: key);

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  WebViewController? controller;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppWebViewModel>.reactive(
      onModelReady: (model) {
        if (Platform.isAndroid) {
          WebView.platform = SurfaceAndroidWebView();
        }
      },
      viewModelBuilder: () => AppWebViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.source?.name ?? ''),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WebView(
                    initialUrl: widget.urlToLoad,
                    onWebViewCreated: (webViewController) {
                      controller = webViewController;
                    },
                    onPageStarted: (url) {
                      model.loadingPercentage = 20;
                    },
                    onProgress: (progress) {
                      model.loadingPercentage = progress;
                    },
                    onPageFinished: (url) {
                      model.loadingPercentage = 100;
                    },
                  ),
                  if (model.loadingPercentage < 100)
                    Card(
                      shape: roundedRectangularShape,
                      elevation: defaultElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: SizedBox(
                          height: buttonHeight,
                          width: buttonHeight,
                          child: CircularProgressIndicator.adaptive(
                            value: model.loadingPercentage / 100.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            DisableWidget(
              disable: controller == null,
              widgetToDisable: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () async {
                        if (await controller!.canGoBack()) {
                          await controller!.goBack();
                        } else {
                          model.showExitWebViewSnackbar();
                          // model.navigationService.back();
                          return;
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () {
                        controller!.reload();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        if (await controller!.canGoForward()) {
                          await controller!.goForward();
                        } else {
                          model.shownoFwdHistorySnackbar();
                          return;
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
