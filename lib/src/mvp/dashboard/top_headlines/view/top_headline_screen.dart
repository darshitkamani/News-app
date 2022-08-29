import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/provider/news_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/args/sort_news_args.dart';
import 'package:news_app/src/mvp/dashboard/top_headlines/provider/top_headline_provider.dart';
import 'package:news_app/src/widgets/widgets.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:news_app/utils/route/route_utils.dart';
import 'package:provider/provider.dart';

class TopHeadlineScreen extends StatefulWidget {
  const TopHeadlineScreen({Key? key}) : super(key: key);

  @override
  State<TopHeadlineScreen> createState() => _TopHeadlineScreenState();
}

class _TopHeadlineScreenState extends State<TopHeadlineScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    TopHeadlineProvider topHeadlineProvider =
        Provider.of(context, listen: false);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          topHeadlineProvider.callAllTopHeadlineApi(context);
        }
      });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      topHeadlineProvider.incPage = 0;
      topHeadlineProvider.clearNewsArticleLst();
      topHeadlineProvider.clearSearchNewsArticleLst();
      topHeadlineProvider.callAllTopHeadlineApi(context);
    });
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtils.blackColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.blackColor,
          title: const Text('Top Headlines'),
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Business"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("entertainment"),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("general"),
                ),
                const PopupMenuItem(
                  value: 4,
                  child: Text("health"),
                ),
                const PopupMenuItem(
                  value: 5,
                  child: Text("science"),
                ),
                const PopupMenuItem(
                  value: 6,
                  child: Text("sports"),
                ),
                const PopupMenuItem(
                  value: 7,
                  child: Text("technology"),
                ),
              ],
              color: Colors.white,
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'business', newsType: NewsType.headlines));
                } else if (value == 2) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'entertainment',
                          newsType: NewsType.headlines));
                } else if (value == 3) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'general', newsType: NewsType.headlines));
                } else if (value == 4) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'health', newsType: NewsType.headlines));
                } else if (value == 5) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'science', newsType: NewsType.headlines));
                } else if (value == 6) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'sports', newsType: NewsType.headlines));
                } else {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'technology', newsType: NewsType.headlines));
                }
              },
            ),
          ],
        ),
        body: Consumer<TopHeadlineProvider>(
            builder: (_, TopHeadlineProvider topHeadlineProvider, __) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InputField(
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        topHeadlineProvider.isSearching = true;
                        topHeadlineProvider.callSearchTopHeadlineApi(context,
                            searchString: text);
                      } else {
                        topHeadlineProvider.isSearching = false;
                        topHeadlineProvider.clearSearchNewsArticleLst();
                      }
                    },
                    controller: searchController,
                    lable: 'Search News',
                  ),
                ),
                const SizedBox(height: 20),
                topHeadlineProvider.isSearching == true
                    ? Expanded(
                        child: (topHeadlineProvider
                                    .searchTopHeadlineResponse.isLeft &&
                                topHeadlineProvider
                                    .searchtopHeadlineList.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: topHeadlineProvider
                                    .searchtopHeadlineList.length,
                                itemBuilder: (_, index) {
                                  return NewsView(
                                      isFavorite: topHeadlineProvider
                                          .searchtopHeadlineList[index]
                                          .isFavorite,
                                      onTap: () {
                                        Navigator.pushNamed(
                                                context,
                                                RouteUtilities
                                                    .newsDetailsScreen,
                                                arguments: NewsDetailsArg(
                                                    // articleList: topHeadlineProvider
                                                    //     .searchtopHeadlineList,
                                                    article: topHeadlineProvider
                                                            .searchtopHeadlineList[
                                                        index]))
                                            .then((value) {
                                          topHeadlineProvider
                                              .checkFavoriteStatus(
                                                  topHeadlineProvider
                                                          .searchtopHeadlineList[
                                                      index]);
                                        });
                                      },
                                      imageURL: topHeadlineProvider
                                          .searchtopHeadlineList[index]
                                          .urlToImage!,
                                      newsHeadline: topHeadlineProvider
                                              .searchtopHeadlineList[index]
                                              .title ??
                                          '',
                                      onBookmarkTap: () {
                                        topHeadlineProvider
                                            .checkHeadlineIsFavorite(
                                                topHeadlineProvider
                                                        .searchtopHeadlineList[
                                                    index],
                                                topHeadlineProvider
                                                    .searchtopHeadlineList);
                                      },
                                      timeStamp: topHeadlineProvider
                                          .searchtopHeadlineList[index]
                                          .publishedAt!);
                                })
                            : const SizedBox(),
                      )
                    : Expanded(
                        child: (topHeadlineProvider
                                    .topHeadlineResponse.isLeft &&
                                topHeadlineProvider.topHeadlineList.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount:
                                    topHeadlineProvider.topHeadlineList.length,
                                itemBuilder: (_, index) {
                                  return NewsView(
                                      isFavorite: topHeadlineProvider
                                          .topHeadlineList[index].isFavorite,
                                      onTap: () {
                                        Navigator.pushNamed(
                                                context,
                                                RouteUtilities
                                                    .newsDetailsScreen,
                                                arguments: NewsDetailsArg(
                                                    // articleList: topHeadlineProvider
                                                    //     .topHeadlineList,
                                                    article: topHeadlineProvider
                                                            .topHeadlineList[
                                                        index]))
                                            .then((value) {
                                          topHeadlineProvider
                                              .checkFavoriteStatus(
                                                  topHeadlineProvider
                                                      .topHeadlineList[index]);
                                        });
                                      },
                                      imageURL: topHeadlineProvider
                                              .topHeadlineList[index]
                                              .urlToImage ??
                                          '',
                                      newsHeadline: topHeadlineProvider
                                              .topHeadlineList[index].title ??
                                          '',
                                      onBookmarkTap: () {
                                        topHeadlineProvider
                                            .checkHeadlineIsFavorite(
                                                topHeadlineProvider
                                                    .topHeadlineList[index],
                                                topHeadlineProvider
                                                    .topHeadlineList);
                                      },
                                      timeStamp: topHeadlineProvider
                                          .topHeadlineList[index].publishedAt!);
                                })
                            : const SizedBox(),
                      )
              ],
            ),
          );
        }));
  }
}
