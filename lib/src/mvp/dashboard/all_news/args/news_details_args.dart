import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';

class NewsDetailsArg {
  final Article? article;
  // final List<Article> articleList;
  NewsDetailsArg({
    required this.article,
    //  required this.articleList
  });
}

enum NewsType { evverything, headlines }
