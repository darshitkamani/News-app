import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_app/src/mvp/dashboard/all_news/api/fetch_all_news_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/api/fetch_all_search_news_api.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/src/mvp/dashboard/top_headlines/api/fetch_all_search_top_headline_api.dart';
import 'package:news_app/src/mvp/dashboard/top_headlines/api/fetch_all_top_headline_api.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/utils.dart';

class TopHeadlineProvider extends ChangeNotifier {
  Either<NewsResponse, Exception> _topHeadlineResponse =
      Right(NoDataFoundException());

  Either<NewsResponse, Exception> get topHeadlineResponse =>
      _topHeadlineResponse;
  set topHeadlineResponse(Either<NewsResponse, Exception> value) {
    _topHeadlineResponse = value;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  List<Article> _topHeadlineList = [];
  List<Article> get topHeadlineList => _topHeadlineList;
  set topHeadlineList(List<Article> value) {
    _topHeadlineList.addAll(value);
    notifyListeners();
  }

  Either<NewsResponse, Exception> _searchTopHeadlineResponse =
      Right(NoDataFoundException());

  Either<NewsResponse, Exception> get searchTopHeadlineResponse =>
      _searchTopHeadlineResponse;
  set searchTopHeadlineResponse(Either<NewsResponse, Exception> value) {
    _searchTopHeadlineResponse = value;
    notifyListeners();
  }

  List<Article> _searchtopHeadlineList = [];
  List<Article> get searchtopHeadlineList => _searchtopHeadlineList;
  set searchtopHeadlineList(List<Article> value) {
    _searchtopHeadlineList.addAll(value);
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
    _topHeadlineList.clear();
    notifyListeners();
  }

  clearSearchNewsArticleLst() {
    _searchtopHeadlineList.clear();
    notifyListeners();
  }

  void callAllTopHeadlineApi(BuildContext context) async {
    incPage = incPage + 1;
    if (incPage <= 0) {
      // newsResponse = Right(FetchingDataException());
    }
    Either<NewsResponse, Exception> resposne =
        await fetchAllTopHeadlineApi(context, page: incPage.toString());
    // try {
    if (resposne.isLeft) {
      if (resposne.left.status == 'ok') {
        topHeadlineResponse = resposne;

        topHeadlineList = resposne.left.articles!;

        for (int i = 0; i < topHeadlineList.length; i++) {
          bool isFavorite = await Favorite().isNewsExists(
              topHeadlineList[i].publishedAt!.millisecondsSinceEpoch);
          topHeadlineList[i].isFavorite = isFavorite;
        }
      } else if (resposne.left.status == 'error') {
        topHeadlineResponse = Right(NoDataFoundException());
      }
    } else if (resposne.isRight) {
      topHeadlineResponse = Right(NoDataFoundException());
    }
  }

  void callSearchTopHeadlineApi(BuildContext context,
      {required String searchString}) async {
    clearSearchNewsArticleLst();

    Either<NewsResponse, Exception> resposne =
        await fetchAllSearchTopHeadlineApi(context,
            page: searchInc.toString(), searchString: searchString);
    // try {
    if (resposne.isLeft) {
      if (resposne.left.status == 'ok') {
        searchTopHeadlineResponse = resposne;

        searchtopHeadlineList = resposne.left.articles!;
        for (int i = 0; i < searchtopHeadlineList.length; i++) {
          bool isFavorite = await Favorite().isNewsExists(
              searchtopHeadlineList[i].publishedAt!.millisecondsSinceEpoch);
          searchtopHeadlineList[i].isFavorite = isFavorite;
        }
      } else if (resposne.left.status == 'error') {
        searchTopHeadlineResponse = Right(NoDataFoundException());
      }
    } else if (resposne.isRight) {
      searchTopHeadlineResponse = Right(NoDataFoundException());
    }
  }

  checkHeadlineIsFavorite(Article article, List<Article> headlineList) async {
    bool isFavorite = await Favorite()
        .isNewsExists(article.publishedAt!.millisecondsSinceEpoch);
    if (isFavorite) {
      await Favorite()
          .removeFromFavorite(article.publishedAt!.millisecondsSinceEpoch)
          .then((value) {
        for (var element in headlineList) {
          if (element.publishedAt!.millisecondsSinceEpoch ==
              article.publishedAt!.millisecondsSinceEpoch) {
            element.isFavorite = false;
            break;
          }
        }
      });
    } else {
      await Favorite().insert(article: article).then((value) {
        for (var element in headlineList) {
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
