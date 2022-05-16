import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          actions: [
            IconButton(
              icon: model.useLightMode()
                  ? const Icon(Icons.wb_sunny_outlined)
                  : const Icon(Icons.wb_sunny),
              onPressed: model.handleBrightnessChange,
              tooltip: "Toggle brightness",
            ),
            PopupMenuButton(
              child: const Icon(Icons.more_vert),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              itemBuilder: (context) {
                return List.generate(model.getColorOptions().length, (index) {
                  return PopupMenuItem(
                      value: index,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              index == model.colorSelected()
                                  ? Icons.color_lens
                                  : Icons.color_lens_outlined,
                              color: model.getColorOptions()[index],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(model.getColorTextOptions[index]))
                        ],
                      ));
                });
              },
              onSelected: model.handleColorSelect,
            ),
          ],
        ),
        body: SafeArea(
          child: model.getViewForIndex(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: model.selectedIndex,
          onDestinationSelected: (int? selectedIndex) {
            if (selectedIndex != null) {
              model.selectedIndex = selectedIndex;
            }
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper),
              label: 'Top Headlines',
            ),
            NavigationDestination(
              icon: Icon(Icons.text_snippet_outlined),
              selectedIcon: Icon(Icons.text_snippet),
              label: 'All',
            ),
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message_rounded),
              label: 'My Feed',
            ),
          ],
        ),
      ),
    );
  }
}
