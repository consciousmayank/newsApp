import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/filter_sheet_viewmodel.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/online_sources_list_view.dart';
import 'package:news_app_mayank/ui/bottom_sheets/filter_sheet/saved_sources_list_view.dart';
import 'package:news_app_mayank/ui/common/app_colors.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/widgets/app_toggle_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FilterSheet extends StatelessWidget {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  const FilterSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FilterSheetViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Container(
        height: screenHeight(context) - kToolbarHeight * 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              request.title!,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            verticalSpaceTiny,
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.description!,
                    style: const TextStyle(fontSize: 14, color: kcMediumGrey),
                    maxLines: 3,
                    softWrap: true,
                  ),
                ),
                AppToggleButton(
                  options: [
                    Text(
                      'All',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Saved',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  optionSelected: (
                    Widget selectedValue,
                    int selectedIndex,
                  ) {
                    model.setIndex(selectedIndex);
                  },
                )
              ],
            ),
            verticalSpaceSmall,
            Expanded(
              child: IndexedStack(
                index: model.currentIndex,
                children: const [
                  OnlineSourcesListView(),
                  SavedSourcesListView(),
                ],
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    completer?.call(
                      SheetResponse(
                        confirmed: false,
                      ),
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    completer?.call(
                      SheetResponse(
                        confirmed: true,
                        data: model.selectedSources,
                      ),
                    );
                  },
                  child: const Text(
                    'Ok',
                  ),
                ),
              ],
            )
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      viewModelBuilder: () => FilterSheetViewModel(),
    );
  }
}
