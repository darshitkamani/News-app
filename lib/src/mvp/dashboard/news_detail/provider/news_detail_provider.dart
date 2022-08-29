import 'package:flutter/cupertino.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/utils/database/favorite_database.dart';

class NewsDetailsProvider extends ChangeNotifier {
  checkHeadlineIsFavorite(Article article) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    if (isFavorite) {
      await Favorite()
          .removeFromFavorite(article.publishedAt!.millisecondsSinceEpoch)
          .then((value) {
        article.isFavorite = false;
      });
    } else {
      await Favorite().insert(article: article).then((value) {
        article.isFavorite = true;
      });
    }
    notifyListeners();
  }
}
