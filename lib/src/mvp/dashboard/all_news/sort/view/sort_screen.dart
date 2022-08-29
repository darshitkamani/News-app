import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/provider/news_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/args/sort_news_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/provider/sort_provider.dart';
import 'package:news_app/src/widgets/widgets.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:news_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SortNewsScreen extends StatefulWidget {
  const SortNewsScreen({required this.sortNewsArgs, Key? key})
      : super(key: key);
  final SortNewsArgs sortNewsArgs;

  @override
  State<SortNewsScreen> createState() => _SortNewsScreenState();
}

class _SortNewsScreenState extends State<SortNewsScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    SortNewsProvider sortNewsProvider = Provider.of(context, listen: false);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          sortNewsProvider.callSortNewsApi(context,
              sortBy: widget.sortNewsArgs.sortBy,
              newsType: widget.sortNewsArgs.newsType);
        }
      });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      sortNewsProvider.incPage = 0;
      sortNewsProvider.sortNewsListClear();
      sortNewsProvider.callSortNewsApi(context,
          sortBy: widget.sortNewsArgs.sortBy,
          newsType: widget.sortNewsArgs.newsType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sort by ${widget.sortNewsArgs.sortBy}'),
          backgroundColor: ColorUtils.blackColor,
        ),
        backgroundColor: ColorUtils.blackColor,
        body: Consumer<SortNewsProvider>(
            builder: (_, SortNewsProvider sortNewsProvider, __) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: (sortNewsProvider.sortNewsResponse.isLeft &&
                          sortNewsProvider.sortNewsList.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: sortNewsProvider.sortNewsList.length,
                          itemBuilder: (_, index) {
                            return NewsView(
                                isFavorite: sortNewsProvider
                                    .sortNewsList[index].isFavorite,
                                onTap: () {
                                  Navigator.pushNamed(context,
                                          RouteUtilities.newsDetailsScreen,
                                          arguments: NewsDetailsArg(
                                              // articleList:
                                              //     sortNewsProvider.sortNewsList,
                                              article: sortNewsProvider
                                                  .sortNewsList[index]))
                                      .then((value) {
                                    sortNewsProvider.checkFavoriteStatus(
                                        sortNewsProvider.sortNewsList[index]);
                                  });
                                },
                                imageURL: sortNewsProvider
                                        .sortNewsList[index].urlToImage ??
                                    '',
                                newsHeadline: sortNewsProvider
                                        .sortNewsList[index].title ??
                                    '',
                                onBookmarkTap: () {
                                  sortNewsProvider.checkSortNewsIsFavorite(
                                      sortNewsProvider.sortNewsList[index],
                                      sortNewsProvider.sortNewsList);
                                },
                                timeStamp: sortNewsProvider
                                    .sortNewsList[index].publishedAt!);
                          })
                      : const SizedBox(),
                )
              ],
            ),
          );
        }));
  }
}
