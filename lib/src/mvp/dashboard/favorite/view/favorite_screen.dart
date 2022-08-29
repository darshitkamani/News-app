import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/favorite/provider/favorite_provider.dart';
import 'package:news_app/src/widgets/custom/custom_news_view.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/utils.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    FavoriteProvider favoriteProvider = Provider.of(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      favoriteProvider.fetchAllFavoriteNews();
    });
    super.initState();
  }

  bool isNewsFavorite(DateTime dateTime) {
    bool isExists = true;
    checkFavorite(dateTime).then((value) {
      isExists = value;
      // setState(() {});
    });
    return isExists;
  }

  Future<bool> checkFavorite(DateTime dateTime) async {
    bool isFavorite =
        await Favorite().isNewsExists(dateTime.millisecondsSinceEpoch);
    return isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
        builder: (_, FavoriteProvider favoriteProvider, __) {
      return Scaffold(
        backgroundColor: ColorUtils.blackColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.blackColor,
          title: const Text('Favorite'),
        ),
        body: Column(children: [
          Expanded(
            child: favoriteProvider.favoriteNewsList.isEmpty
                ? Center(
                    child: Text('No News Found!'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoriteProvider.favoriteNewsList.length,
                    itemBuilder: (_, index) {
                      return NewsView(
                          newsHeadline:
                              favoriteProvider.favoriteNewsList[index].title!,
                          isFavorite: favoriteProvider
                                  .favoriteNewsList[index].isFavorite ??
                              false,
                          imageURL: favoriteProvider
                              .favoriteNewsList[index].urlToImage,
                          timeStamp: favoriteProvider
                                  .favoriteNewsList[index].publishedAt ??
                              DateTime.now(),
                          onTap: () {
                            Navigator.pushNamed(
                                    context, RouteUtilities.newsDetailsScreen,
                                    arguments: NewsDetailsArg(
                                        // articleList:
                                        //     favoriteProvider.favoriteNewsList,
                                        article: favoriteProvider
                                            .favoriteNewsList[index]))
                                .then((value) {
                              favoriteProvider.checkFavoriteStatus(
                                  favoriteProvider.favoriteNewsList[index]);
                            });
                          },
                          onBookmarkTap: () async {
                            favoriteProvider.checkNewsIsFavrite(
                                favoriteProvider.favoriteNewsList[index]);
                          });
                    }),
          )
        ]),
      );
    });
  }
}
