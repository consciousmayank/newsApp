import 'package:flutter/material.dart';
import 'package:news_app_mayank/enums/news_list_type.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:news_app_mayank/ui/views/news_list/all_news_filter_widget.dart';
import 'package:news_app_mayank/ui/views/news_list/top_headlines_filter_widget.dart';
import 'package:news_app_mayank/ui/views/source_view/source_view_widget.dart';
import 'package:news_app_mayank/ui/widgets/app_bookmark_widget.dart';
import 'package:news_app_mayank/ui/widgets/app_inkwell.dart';
import 'package:news_app_mayank/ui/widgets/app_sliver_appbar.dart';
import 'package:stacked/stacked.dart';
import 'news_list_viewmodel.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;

class NewsListView extends StatefulWidget {
  final List<complete_source.Sources> sourcesList;
  const NewsListView(
      {Key? key, required this.newsListType, this.sourcesList = const []})
      : super(key: key);

  const NewsListView.withSources({
    Key? key,
    required this.sourcesList,
  })  : newsListType = NewsListType.mySavedSources,
        super(key: key);
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                              label: const Text('Search'),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultBorder),
                              ),
                            ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    if (widget.newsListType == NewsListType.topHeadlines)
                      const TopHeadlinesFilterWidget(),
                    if (widget.newsListType == NewsListType.everything)
                      const AllNewsFilterWidget(),
                  ],
                ),
              ),
            model.busy(getNewsBusyObjectKey)
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
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
                                              strokeWidth: 8,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                model.newsArticles.articles
                                                        ?.elementAt(index)
                                                        .title ??
                                                    '--',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 4,
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text('Source'),
                                                  horizontalSpaceTiny,
                                                  SourceViewWidget(
                                                    key: Key(
                                                      index.toString(),
                                                    ),
                                                    sourceName: model
                                                            .newsArticles
                                                            .articles
                                                            ?.elementAt(index)
                                                            .source
                                                            ?.name ??
                                                        '',
                                                    onChipClicked: (
                                                        {required bool value}) {
                                                      model.saveSource(
                                                        source: model
                                                            .newsArticles
                                                            .articles
                                                            ?.elementAt(index)
                                                            .source,
                                                        selectedArticleIndex:
                                                            index,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
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
                                    ),
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
