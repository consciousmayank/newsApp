import 'package:flutter/material.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/ui/views/news_list/news_list_view.dart';
import 'package:news_app_mayank/ui/widgets/tab_text_widget.dart';
import 'package:stacked/stacked.dart';
import 'my_feed_viewmodel.dart';

class MyFeedView extends StatelessWidget {
  const MyFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyFeedViewModel>.reactive(
      viewModelBuilder: () => MyFeedViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color:
                            Theme.of(context).tabBarTheme.unselectedLabelColor,
                        child: const TabBar(
                          isScrollable: false,
                          tabs: [
                            Tab(
                              child: TabTextWidget(
                                title: 'Saved Articles',
                              ),
                            ),
                            Tab(
                              child: TabTextWidget(
                                title: 'Saved Sources',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            NewsListView(
                              key: Key('1'),
                              newsListType: NewsListType.mySavedSources,
                            ),
                            NewsListView(
                              key: Key('2'),
                              newsListType: NewsListType.mySavedSources,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
