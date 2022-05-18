import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';

class AppSliverAppbar extends StatelessWidget {
  const AppSliverAppbar({
    Key? key,
    required this.child,
  })  : background = null,
        pinned = true,
        toolBarHeight = kToolbarHeight,
        showAppFlexBackground = false,
        super(
          key: key,
        );

  const AppSliverAppbar.nonPinned({
    Key? key,
    required this.child,
    this.toolBarHeight = kToolbarHeight * 1.5,
  })  : background = null,
        pinned = false,
        showAppFlexBackground = false,
        super(
          key: key,
        );

  const AppSliverAppbar.withBackground({
    Key? key,
    required this.child,
    required this.background,
    this.toolBarHeight = kToolbarHeight * 1.5,
  })  : showAppFlexBackground = true,
        pinned = true,
        super(
          key: key,
        );

  const AppSliverAppbar.withBackgroundNonPinned({
    Key? key,
    required this.child,
    required this.background,
    this.toolBarHeight = kToolbarHeight * 1.5,
  })  : showAppFlexBackground = true,
        pinned = false,
        super(
          key: key,
        );

  final Widget? background;
  final Widget child;
  final bool pinned;
  final bool showAppFlexBackground;
  final double toolBarHeight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: false,
      toolbarHeight: toolBarHeight,
      automaticallyImplyLeading: false,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
        background: showAppFlexBackground
            ? background ??
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        defaultBorder,
                      ),
                      bottomRight: Radius.circular(
                        defaultBorder,
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor,
                      ],
                    ),
                  ),
                )
            : null,
        collapseMode: CollapseMode.pin,
      ),
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
      floating: true,
      pinned: pinned,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      elevation: 0,
      title: child,
    );
  }
}
