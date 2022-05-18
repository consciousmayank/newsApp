import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/widgets/app_inkwell.dart';

class AppBookMarkWidget extends StatelessWidget {
  const AppBookMarkWidget({
    Key? key,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppInkwell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade400.withAlpha(120),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(defaultBorder),
            bottomLeft: Radius.circular(defaultBorder),
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.bookmark_rounded,
                color: Theme.of(context).navigationRailTheme.backgroundColor,
              )
            : const Icon(Icons.bookmark_outline_sharp),
      ),
    );
  }
}
