import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/views/source_view/source_view_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SourceViewWidget extends StatelessWidget {
  const SourceViewWidget({
    Key? key,
    required this.sourceName,
    required this.onChipClicked,
  }) : super(key: key);

  final Function({required bool value}) onChipClicked;
  final String sourceName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SourceViewWidgetModel>.reactive(
      onModelReady: (model) => model.isSourceSaved(sourceName: sourceName),
      builder: (context, model, child) => model.isBusy
          ? const CircularProgressIndicator.adaptive()
          : InputChip(
              backgroundColor: model.selectedColor,
              padding: const EdgeInsets.all(2.0),
              label: Text(
                model.source.name ?? sourceName,
              ),
              selected: model.source.isSaved,
              selectedColor: model.selectedColor,
              onSelected: (bool selected) {
                onChipClicked(value: selected);
                model.setSourceSelected(value: selected);
              },
            ),
      viewModelBuilder: () => SourceViewWidgetModel(),
    );
  }
}
