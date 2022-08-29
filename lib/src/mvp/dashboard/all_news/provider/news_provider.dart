import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_app/src/mvp/dashboard/all_news/api/fetch_all_news_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/api/fetch_all_search_news_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/utils.dart';

class NewsProvider extends ChangeNotifier {
  Either<NewsResponse, Exception> _newsResponse = Right(NoDataFoundException());

  Either<NewsResponse, Exception> get newsResponse => _newsResponse;
  set newsResponse(Either<NewsResponse, Exception> value) {
    _newsResponse = value;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  List<Article> _articlesList = [];
  List<Article> get articlesList => _articlesList;
  set articlesList(List<Article> value) {
    _articlesList.addAll(value);
    notifyListeners();
  }

  Either<NewsResponse, Exception> _searchNewsResponse =
      Right(NoDataFoundException());

  Either<NewsResponse, Exception> get searchNewsResponse => _searchNewsResponse;
  set searchNewsResponse(Either<NewsResponse, Exception> value) {
    _searchNewsResponse = value;
    notifyListeners();
  }

  List<Article> _searchArticlesList = [];
  List<Article> get searchArticlesList => _searchArticlesList;
  set searchArticlesList(List<Article> value) {
    _searchArticlesList.addAll(value);
    notifyListeners();
  }

  int _incPage = 0;
  int get incPage => _incPage;

  set incPage(int value) {
    _incPage = value;
    notifyListeners();
  }

  int _searchInc = 0;
  int get searchInc => _searchInc;

  set searchInc(int value) {
    _searchInc = value;
    notifyListeners();
  }

  clearNewsArticleLst() {
    _articlesList.clear();
    notifyListeners();
  }

  clearSearchNewsArticleLst() {
    _searchArticlesList.clear();
    notifyListeners();
  }

  void callAllNewsApi(BuildContext context) async {
    incPage = incPage + 1;
    if (incPage <= 0) {
      // newsResponse = Right(FetchingDataException());
    }
    Either<NewsResponse, Exception> resposne =
        await fetchAllNewsApi(context, page: incPage.toString());
    // try {
    if (resposne.isLeft) {
      if (resposne.left.status == 'ok') {
        newsResponse = resposne;

        articlesList = resposne.left.articles!;
        for (int i = 0; i < articlesList.length; i++) {
          bool isFavorite = await isNewsFavorite(articlesList[i].publishedAt!);
          articlesList[i].isFavorite = isFavorite;
        }
      } else if (resposne.left.status == 'error') {
        newsResponse = Right(NoDataFoundException());
      }
    } else if (resposne.isRight) {
      newsResponse = Right(NoDataFoundException());
    }
    notifyListeners();
  }

  void callSearchNewsApi(BuildContext context,
      {required String searchString}) async {
    clearSearchNewsArticleLst();

    Either<NewsResponse, Exception> resposne = await fetchAllSearchNewsApi(
        context,
        page: searchInc.toString(),
        searchString: searchString);
    // try {
    if (resposne.isLeft) {
      if (resposne.left.status == 'ok') {
        searchNewsResponse = resposne;

        searchArticlesList = resposne.left.articles!;
        for (int i = 0; i < searchArticlesList.length; i++) {
          bool isFavorite =
              await isNewsFavorite(searchArticlesList[i].publishedAt!);
          searchArticlesList[i].isFavorite = isFavorite;
        }
      } else if (resposne.left.status == 'error') {
        searchNewsResponse = Right(NoDataFoundException());
      }
    } else if (resposne.isRight) {
      searchNewsResponse = Right(NoDataFoundException());
    }
    notifyListeners();
  }

  checkNewsIsFavorite(Article article, List<Article> articleList) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    if (isFavorite) {
      await Favorite()
          .removeFromFavorite(article.publishedAt!.millisecondsSinceEpoch)
          .then((value) {
        for (var element in articleList) {
          if (element.publishedAt!.millisecondsSinceEpoch ==
              article.publishedAt!.millisecondsSinceEpoch) {
            element.isFavorite = false;
            break;
          }
        }
      });
    } else {
      await Favorite().insert(article: article).then((value) {
        for (var element in articleList) {
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

  Future<bool> isNewsFavorite(DateTime dateTime) async {
    bool isFavorite =
        await Favorite().isNewsExists(dateTime.millisecondsSinceEpoch);
    return isFavorite;
  }

  checkFavoriteStatus(Article article) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    article.isFavorite = isFavorite;
    notifyListeners();
  }
}
