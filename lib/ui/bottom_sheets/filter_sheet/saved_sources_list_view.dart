import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/filter_sheet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SavedSourcesListView extends ViewModelWidget<FilterSheetViewModel> {
  const SavedSourcesListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, FilterSheetViewModel viewModel) {
    return viewModel.busy(getSourcesFromDbBusyObject)
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: viewModel.checkIfSelectedSourceIsInDb(index: index),
                title: Text(viewModel.savedSources[index].name ?? ''),
                onChanged: (bool? value) {
                  viewModel.updateSelectedSource(index: index, value: value);
                },
              );
            },
            itemCount: viewModel.savedSources.length,
          );
  }
}
