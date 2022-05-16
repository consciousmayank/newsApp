import 'package:flutter/material.dart';

class DisableWidget extends StatelessWidget {
  const DisableWidget({
    Key? key,
    required this.disable,
    required this.widgetToDisable,
  }) : super(key: key);

  final bool disable;
  final Widget widgetToDisable;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disable ? 0.4 : 1.0,
      child: AbsorbPointer(
        absorbing: disable,
        child: widgetToDisable,
      ),
    );
  }
}
