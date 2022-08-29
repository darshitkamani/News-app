import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_app/src/mvp/dashboard/all_news/api/fetch_all_news_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/api/call_sort_headlines_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/api/call_sort_news_api.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/utils.dart';

class SortNewsProvider extends ChangeNotifier {
  Either<NewsResponse, Exception> _sortNewsResponse =
      Right(NoDataFoundException());

  Either<NewsResponse, Exception> get sortNewsResponse => _sortNewsResponse;
  set sortNewsResponse(Either<NewsResponse, Exception> value) {
    _sortNewsResponse = value;
    notifyListeners();
  }

  List<Article> _sortNewsList = [];
  List<Article> get sortNewsList => _sortNewsList;
  set sortNewsList(List<Article> value) {
    _sortNewsList.addAll(value);
    notifyListeners();
  }

  sortNewsListClear() {
    _sortNewsList.clear();

    notifyListeners();
  }

  int _incPage = 0;
  int get incPage => _incPage;

  set incPage(int value) {
    _incPage = value;
    notifyListeners();
  }

  void callSortNewsApi(BuildContext context,
      {required String sortBy, required NewsType newsType}) async {
    if (incPage <= 0) {
      // newsResponse = Right(FetchingDataException());
    }
    incPage = incPage + 1;
    Either<NewsResponse, Exception> resposne = Right(NoDataFoundException());
    if (newsType == NewsType.evverything) {
      resposne = await fetchSortNewsApi(context,
          page: incPage.toString(), sortBy: sortBy);
    } else {
      resposne = await fetchSortHeadlinesNewsApi(context,
          page: incPage.toString(), category: sortBy);
    }

    // try {
    if (resposne.isLeft) {
      if (resposne.left.status == 'ok') {
        sortNewsResponse = resposne;
        sortNewsList = resposne.left.articles!;
        for (int i = 0; i < sortNewsList.length; i++) {
          for (int i = 0; i < sortNewsList.length; i++) {
            bool isFavorite = await Favorite().isNewsExists(
                sortNewsList[i].publishedAt!.millisecondsSinceEpoch);
            sortNewsList[i].isFavorite = isFavorite;
          }
        }
      } else if (resposne.left.status == 'error') {
        sortNewsResponse = Right(NoDataFoundException());
      }
    } else if (resposne.isRight) {
      sortNewsResponse = Right(NoDataFoundException());
    }
  }

  checkSortNewsIsFavorite(Article article, List<Article> sortNewsList) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    if (isFavorite) {
      await Favorite()
          .removeFromFavorite(article.publishedAt!.millisecondsSinceEpoch)
          .then((value) {
        for (var element in sortNewsList) {
          if (element.publishedAt!.millisecondsSinceEpoch ==
              article.publishedAt!.millisecondsSinceEpoch) {
            element.isFavorite = false;
            break;
          }
        }
      });
    } else {
      await Favorite().insert(article: article).then((value) {
        for (var element in sortNewsList) {
          if (element.publishedAt!.millisecondsSinceEpoch ==
              article.publishedAt!.millisecondsSinceEpoch) {
            element.isFavorite = true;
            break;
          }
        }
      });
    }
    notifyListeners();
  }

  checkFavoriteStatus(Article article) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    article.isFavorite = isFavorite;
    notifyListeners();
  }
}
