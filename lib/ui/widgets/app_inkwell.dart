import 'package:flutter/material.dart';

class AppInkwell extends StatelessWidget {
  const AppInkwell({
    Key? key,
    required this.child,
    this.onHover,
    required this.onTap,
    this.transparentInteraction = false,
  })  : isCustomBorder = false,
        borderderRadius = null,
        super(key: key);

  const AppInkwell.withBorder({
    Key? key,
    required this.child,
    required this.onTap,
    this.onHover,
    this.borderderRadius,
    this.transparentInteraction = false,
  })  : isCustomBorder = true,
        super(key: key);

  final Function()? onTap;
  final BorderRadiusGeometry? borderderRadius;
  final Widget child;
  final bool isCustomBorder;
  final ValueChanged<bool>? onHover;
  final bool transparentInteraction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: onHover,
      customBorder: isCustomBorder
          ? RoundedRectangleBorder(
              borderRadius: borderderRadius ?? BorderRadius.circular(50),
            )
          : null,
      hoverColor: Theme.of(context).hoverColor,
      child: child,
      onTap: onTap,
    );
  }
}
