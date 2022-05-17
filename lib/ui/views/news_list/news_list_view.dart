import 'package:flutter/material.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/widgets/app_bookmark_widget.dart';
import 'package:news_app_mayank/ui/widgets/app_inkwell.dart';
import 'package:news_app_mayank/ui/widgets/app_sliver_appbar.dart';
import 'package:stacked/stacked.dart';
import 'news_list_viewmodel.dart';

class NewsListView extends StatefulWidget {
  const NewsListView({
    Key? key,
    required this.newsListType,
  }) : super(key: key);
  final NewsListType newsListType;

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsListViewModel>.reactive(
      onModelReady: (model) => model.init(
        newsListType: widget.newsListType,
      ),
      viewModelBuilder: () => NewsListViewModel(),
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            if (widget.newsListType == NewsListType.everything ||
                widget.newsListType == NewsListType.topHeadlines)
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
                            context: context,
                            focusNode: _searchFocusNode,
                          );
                        },
                        decoration: const InputDecoration()
                            .applyDefaults(
                                Theme.of(context).inputDecorationTheme)
                            .copyWith(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultBorder),
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
            model.busy(getNewsBusyObjectKey)
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : model.getListLength() == 0
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height:
                              widget.newsListType == NewsListType.everything ||
                                      widget.newsListType ==
                                          NewsListType.topHeadlines
                                  ? MediaQuery.of(context).size.height * 0.56
                                  : MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                widget.newsListType ==
                                            NewsListType.everything ||
                                        widget.newsListType ==
                                            NewsListType.topHeadlines
                                    ? 'No News Found. Kindly search for something else. Or change the filters.'
                                    : 'No Saved Articles Found. Kindly add some articles to your saved articles.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          ((context, index) => index >= model.getListLength()
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: model
                                          .busy(getNextPageNewsBusyObjectKey)
                                      ? SizedBox(
                                          width: 16,
                                          height: 32,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              strokeWidth: 12,
                                            ),
                                          ),
                                        )
                                      : model.getListLength() <
                                              (model.newsArticles
                                                      .totalResults ??
                                                  0)
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
                                      onTap: () => model.openArticle(index),
                                      borderderRadius: defaultBorderRadius,
                                      child: Card(
                                        shape: roundedRectangularShape,
                                        elevation: defaultElevation,
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          children: [
                                            model.newsArticles.articles !=
                                                        null &&
                                                    model.newsArticles.articles!
                                                        .isNotEmpty &&
                                                    model.newsArticles.articles!
                                                            .elementAt(index)
                                                            .urlToImage !=
                                                        null
                                                ? Image.network(model
                                                    .newsArticles.articles!
                                                    .elementAt(index)
                                                    .urlToImage!)
                                                : const AspectRatio(
                                                    aspectRatio: 2,
                                                    child: FlutterLogo()),
                                            ListTile(
                                              title: Text(
                                                model.newsArticles.articles
                                                        ?.elementAt(index)
                                                        .title ??
                                                    '--',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              subtitle: AppInkwell.withBorder(
                                                borderderRadius:
                                                    defaultBorderRadius,
                                                onTap: () {
                                                  model.saveSource(
                                                    source: model
                                                        .newsArticles.articles
                                                        ?.elementAt(index)
                                                        .source,
                                                    selectedArticleIndex: index,
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black87,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            defaultBorderRadius,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          if (model.newsArticles
                                                                  .articles
                                                                  ?.elementAt(
                                                                      index)
                                                                  .source
                                                                  ?.isSaved ==
                                                              true)
                                                            const Icon(
                                                                Icons.check),
                                                          Text(
                                                            model.newsArticles
                                                                    .articles
                                                                    ?.elementAt(
                                                                        index)
                                                                    .source
                                                                    ?.name ??
                                                                '--',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelMedium,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 4,
                                        top: 4,
                                      ),
                                      child: AppBookMarkWidget(
                                        isSelected: model.newsArticles.articles
                                                ?.elementAt(index)
                                                .isBookmarked ==
                                            true,
                                        onTap: () {
                                          hideKeyboard(
                                            context: context,
                                            focusNode: _searchFocusNode,
                                          );
                                          model.setBookMarked(index: index);
                                        },
                                      ),
                                    )
                                  ],
                                )),
                          childCount: model.getListLength() + 1,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
