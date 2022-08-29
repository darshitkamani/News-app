import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/src/mvp/auth/gooogle_login/provider/google_login_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/provider/news_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/args/sort_news_args.dart';
import 'package:news_app/src/widgets/widgets.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:news_app/utils/database/database.dart';
import 'package:news_app/utils/database/database_utils.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/route/route_utils.dart';
import 'package:provider/provider.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    NewsProvider newsProvider = Provider.of(context, listen: false);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          newsProvider.callAllNewsApi(context);
        }
      });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      newsProvider.incPage = 0;
      newsProvider.clearNewsArticleLst();
      newsProvider.clearSearchNewsArticleLst();
      newsProvider.callAllNewsApi(context);
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
          title: const Text('All News'),
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Relevancy"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Popularity"),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("Published At"),
                ),
              ],
              color: Colors.white,
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'relevancy', newsType: NewsType.evverything));
                } else if (value == 2) {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'popularity',
                          newsType: NewsType.evverything));
                } else {
                  Navigator.pushNamed(context, RouteUtilities.sortNewsScreen,
                      arguments: SortNewsArgs(
                          sortBy: 'publishedAt',
                          newsType: NewsType.evverything));
                }
              },
            ),
            IconButton(
                onPressed: () {
                  GoogleLoginProvider googleLoginProvider =
                      Provider.of(context, listen: false);

                  googleLoginProvider.signOutFromGoogle();
                  Navigator.pushReplacementNamed(
                      context, RouteUtilities.googleLoginScreen);
                  DatabaseHepler().clearDatabase();
                },
                icon: const Icon(Icons.logout))
            // IconButton(
            //     onPressed: () {
            //       showMenu(
            //         context: context,
            //         position: const RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
            //         items: [
            //           PopupMenuItem(
            //             onTap: () {
            //               Navigator.pushNamed(
            //                   context, RouteUtilities.sortNewsScreen,
            //                   arguments: SortNewsArgs(sortBy: 'relevancy'));
            //             },
            //             child: const Text('Relevancy'),
            //           ),
            //           PopupMenuItem<String>(
            //             onTap: () {},
            //             child: const Text('Popularity'),
            //           ),
            //           PopupMenuItem<String>(
            //             onTap: () {},
            //             child: const Text('Published At'),
            //           ),
            //         ],
            //         elevation: 8.0,
            //       );
            //     },
            //     icon: const Icon(Icons.sort))
          ],
        ),
        body:
            Consumer<NewsProvider>(builder: (_, NewsProvider newsProvider, __) {
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
                        newsProvider.isSearching = true;
                        newsProvider.callSearchNewsApi(context,
                            searchString: text);
                      } else {
                        newsProvider.isSearching = false;
                        newsProvider.clearSearchNewsArticleLst();
                      }
                    },
                    controller: searchController,
                    lable: 'Search News',
                  ),
                ),
                const SizedBox(height: 20),
                newsProvider.isSearching == true
                    ? Expanded(
                        child: (newsProvider.searchNewsResponse.isLeft &&
                                newsProvider.searchArticlesList.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount:
                                    newsProvider.searchArticlesList.length,
                                itemBuilder: (_, index) {
                                  return NewsView(
                                      isFavorite: newsProvider
                                          .searchArticlesList[index].isFavorite,
                                      onTap: () {
                                        Navigator.pushNamed(
                                                context,
                                                RouteUtilities
                                                    .newsDetailsScreen,
                                                arguments: NewsDetailsArg(
                                                    // articleList: newsProvider
                                                    //     .searchArticlesList,
                                                    article: newsProvider
                                                            .searchArticlesList[
                                                        index]))
                                            .then((value) {
                                          newsProvider.checkFavoriteStatus(
                                              newsProvider
                                                  .searchArticlesList[index]);
                                        });
                                      },
                                      imageURL: newsProvider
                                          .searchArticlesList[index]
                                          .urlToImage!,
                                      newsHeadline: newsProvider
                                              .searchArticlesList[index]
                                              .title ??
                                          '',
                                      onBookmarkTap: () {
                                        newsProvider.checkNewsIsFavorite(
                                            newsProvider
                                                .searchArticlesList[index],
                                            newsProvider.searchArticlesList);
                                      },
                                      timeStamp: newsProvider
                                          .searchArticlesList[index]
                                          .publishedAt!);
                                })
                            : const SizedBox(),
                      )
                    : Expanded(
                        child: (newsProvider.newsResponse.isLeft &&
                                newsProvider.articlesList.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: newsProvider.articlesList.length,
                                itemBuilder: (_, index) {
                                  return NewsView(
                                      isFavorite: newsProvider
                                          .articlesList[index].isFavorite,
                                      onTap: () {
                                        Navigator.pushNamed(
                                                context,
                                                RouteUtilities
                                                    .newsDetailsScreen,
                                                arguments: NewsDetailsArg(
                                                    // articleList:
                                                    //     newsProvider.articlesList,
                                                    article: newsProvider
                                                        .articlesList[index]))
                                            .then((value) {
                                          newsProvider.checkFavoriteStatus(
                                              newsProvider.articlesList[index]);
                                        });
                                      },
                                      imageURL: newsProvider
                                          .articlesList[index].urlToImage!,
                                      newsHeadline: newsProvider
                                              .articlesList[index].title ??
                                          '',
                                      onBookmarkTap: () async {
                                        newsProvider.checkNewsIsFavorite(
                                            newsProvider.articlesList[index],
                                            newsProvider.articlesList);
                                      },
                                      timeStamp: newsProvider
                                          .articlesList[index].publishedAt!);
                                })
                            : const SizedBox(),
                      )
              ],
            ),
          );
        }));
  }
}
