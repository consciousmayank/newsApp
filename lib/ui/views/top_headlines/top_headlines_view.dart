import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/widgets/app_bookmark_widget.dart';
import 'package:news_app_mayank/ui/widgets/app_inkwell.dart';
import 'package:news_app_mayank/ui/widgets/app_sliver_appbar.dart';
import 'package:stacked/stacked.dart';
import 'top_headlines_viewmodel.dart';

class TopHeadlinesView extends StatelessWidget {
  TopHeadlinesView({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopHeadlinesViewModel>.reactive(
      onModelReady: (model) => model.getTopHeadlines(),
      viewModelBuilder: () => TopHeadlinesViewModel(),
      builder: (context, model, child) => Scaffold(
          body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          AppSliverAppbar.nonPinned(
            toolBarHeight: kToolbarHeight * 1.5,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) => model.queryString = value,
                    onEditingComplete: () {
                      model.queryString = _searchController.text.trim();
                      hideKeyboard(
                          context: context, focusNode: _searchFocusNode);
                    },
                    decoration: const InputDecoration()
                        .applyDefaults(Theme.of(context).inputDecorationTheme)
                        .copyWith(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultBorder),
                          ),
                        ),
                  ),
                ),
                horizontalSpaceTiny,
                ElevatedButton(
                  onPressed: model.showFiltersBottomSheet,
                  child: const Text('Filters'),
                )
              ],
            ),
          ),
          model.busy(getTopHeadlinesBusyObjectKey)
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => index >= model.getListLength()
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: model.busy(getNextTopHeadlinesBusyObjectKey)
                                ? SizedBox(
                                    width: 16,
                                    height: 32,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        strokeWidth: 12,
                                      ),
                                    ),
                                  )
                                : model.getListLength() <
                                        (model.topHeadlines.totalResults ?? 0)
                                    ? OutlinedButton(
                                        onPressed: () {
                                          model.pageNumber =
                                              model.pageNumber + 1;
                                        },
                                        child: const Text(
                                          'Load More',
                                        ),
                                      )
                                    : Container(),
                          )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              AppInkwell.withBorder(
                                onTap: () {
                                  hideKeyboard(
                                      context: context,
                                      focusNode: _searchFocusNode);
                                  model.openArticle(index);
                                },
                                borderderRadius: defaultBorderRadius,
                                child: Card(
                                  shape: roundedRectangularShape,
                                  elevation: defaultElevation,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(
                                      children: [
                                        model.topHeadlines.articles != null &&
                                                model.topHeadlines.articles!
                                                    .isNotEmpty &&
                                                model.topHeadlines.articles!
                                                        .elementAt(index)
                                                        .urlToImage !=
                                                    null
                                            ? Image.network(model
                                                .topHeadlines.articles!
                                                .elementAt(index)
                                                .urlToImage!)
                                            : const AspectRatio(
                                                aspectRatio: 2,
                                                child: FlutterLogo()),
                                        ListTile(
                                          title: Text(
                                            model.topHeadlines.articles
                                                    ?.elementAt(index)
                                                    .title ??
                                                '--',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          subtitle: Text(
                                            model.topHeadlines.articles
                                                    ?.elementAt(index)
                                                    .source
                                                    ?.name ??
                                                '--',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4,
                                  top: 4,
                                ),
                                child: AppBookMarkWidget(
                                  isSelected: model.topHeadlines.articles
                                          ?.elementAt(index)
                                          .isBookmarked ==
                                      true,
                                  onTap: () {
                                    model.setBookMarked(index: index);
                                  },
                                ),
                              )
                            ],
                          ),
                    childCount: model.getListLength() + 1,
                  ),
                ),
        ],
      )),
    );
  }
}
