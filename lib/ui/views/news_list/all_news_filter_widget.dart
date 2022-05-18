import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/views/news_list/news_list_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AllNewsFilterWidget extends ViewModelWidget<NewsListViewModel> {
  const AllNewsFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, NewsListViewModel viewModel) {
    return PopupMenuButton(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorder),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1.5,
          ),
        ),
        height: kToolbarHeight * 0.9,
        width: kToolbarHeight * 0.9,
        child: const Icon(Icons.sort),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(viewModel.allNewsfilterOptions.length, (index) {
          return PopupMenuItem(
            value: index,
            child: Text(
              viewModel.allNewsfilterOptions[index],
            ),
          );
        });
      },
      onSelected: viewModel.handleAllNewsFilterOptionSelection,
    );
  }
}
