import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';

class AppToggleButton extends StatefulWidget {
  final Function(
    Widget selectedValue,
    int selectedIndex,
  ) optionSelected;
  final List<Widget> options;
  final bool isSingleSelection;
  final int preSelectedIndex;

  const AppToggleButton({
    Key? key,
    required this.options,
    required this.optionSelected,
    this.preSelectedIndex = 0,
  })  : isSingleSelection = true,
        super(key: key);

  const AppToggleButton.multipleSelection({
    Key? key,
    required this.options,
    required this.optionSelected,
    this.preSelectedIndex = 0,
  })  : isSingleSelection = false,
        super(key: key);

  @override
  _AppToggleButtonState createState() => _AppToggleButtonState();
}

class _AppToggleButtonState extends State<AppToggleButton> {
  late List<bool> selectionList;

  @override
  void initState() {
    selectionList = List.generate(
      widget.options.length,
      (index) => index == widget.preSelectedIndex ? true : false,
    );
    super.initState();
  }

  void setSelectionList({required int index}) {}

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      selectedColor: Theme.of(context).primaryColor,
      children: widget.options,
      textStyle: Theme.of(context).textTheme.caption,
      borderRadius: defaultBorderRadius,
      onPressed: (int index) {
        //check if single selection or multiple selection
        //If single selection, then set whole selectionList as the selection which is at clicked index and set the clicked index as inverse of what it was.
        //This is like if selctionList had [true, false, false] and we pressed index 1, then it would be [false, true, false]. Only one can be true.
        if (widget.isSingleSelection) {
          bool initialValue = selectionList[index];
          if (!initialValue) {
            selectionList = List.generate(
              widget.options.length,
              (index) => initialValue,
            );
            selectionList[index] = !initialValue;
          }
        }
        //If mutiple selection, make the clicked index as inverse of what it was.
        //This is like if selctionList had [true, false, false] and we pressed index 2, then it would be [true, false, true]
        else {
          selectionList[index] = !selectionList[index];
        }
        widget.optionSelected(
          widget.options.elementAt(
            index,
          ),
          index,
        );
        setState(() {});
      },
      color: Theme.of(context).primaryColorLight.withAlpha(100),
      selectedBorderColor: Theme.of(context).primaryColorDark,
      borderColor: Theme.of(context).primaryColorLight.withAlpha(100),
      isSelected: selectionList,
    );
  }
}
