import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/filter_sheet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class OnlineSourcesListView extends ViewModelWidget<FilterSheetViewModel> {
  const OnlineSourcesListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, FilterSheetViewModel viewModel) {
    return viewModel.busy(getSourcesFromTopHeadlinesBusyObject)
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: viewModel.checkIfSelectedSourceIsInOnlineSources(
                    index: index),
                title: Text(viewModel.onlineSources.sources?[index].name ?? ''),
                onChanged: (bool? value) {
                  viewModel.updateSelectedSourceFromOnlineSourcesList(
                      index: index, value: value);
                },
              );
            },
            itemCount: viewModel.onlineSources.sources?.length,
          );
  }
}
