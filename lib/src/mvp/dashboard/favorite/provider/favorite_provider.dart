import 'package:flutter/cupertino.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/utils/database/favorite_database.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Article> _favoriteNewsList = [];
  List<Article> get favoriteNewsList => _favoriteNewsList;
  set favoriteNewsList(List<Article> value) {
    _favoriteNewsList = value;
    _favoriteNewsList = _favoriteNewsList.reversed.toList();
    notifyListeners();
  }

  fetchAllFavoriteNews() async {
    favoriteNewsList = await Favorite().fetchDatabase();
    notifyListeners();
  }

  checkNewsIsFavrite(Article article) async {
    // bool isFavorite = await Favorite()
    //     .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    // if (isFavorite) {
    await Favorite()
        .removeFromFavorite(article.publishedAt!.millisecondsSinceEpoch)
        .then((value) {
      for (int i = 0; i < favoriteNewsList.length; i++) {
        if (favoriteNewsList[i].publishedAt!.millisecondsSinceEpoch ==
            article.publishedAt!.millisecondsSinceEpoch) {
          favoriteNewsList.removeAt(i);
          break;
        }
      }
    });
    // }
    notifyListeners();
  }

  checkFavoriteStatus(Article article) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    article.isFavorite = isFavorite;
    if (article.isFavorite == false) {
      for (int i = 0; i < favoriteNewsList.length; i++) {
        if (favoriteNewsList[i].publishedAt!.millisecondsSinceEpoch ==
            article.publishedAt!.millisecondsSinceEpoch) {
          favoriteNewsList.removeAt(i);
          break;
        }
      }
    }
    notifyListeners();
  }
}
