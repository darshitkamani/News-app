// ignore_for_file: missing_required_param

import 'package:flutter/material.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/utils/database/database.dart';
import 'package:news_app/utils/database/database_utils.dart';

class Favorite {
  static var db = DatabaseHepler.database;
  Future<void> insert({required Article article}) async {
    Map<String, dynamic> toMap = {
      DBUtils.favoriteContent: article.content ?? '',
      DBUtils.favoriteDescrition: article.description,
      DBUtils.favoriteTitle: article.title,
      DBUtils.favoriteImage: article.urlToImage,
      DBUtils.favoriteNewsId: article.publishedAt!.millisecondsSinceEpoch,
    };

    bool isFavorite =
        await isNewsExists(article.publishedAt!.millisecondsSinceEpoch);

    if (!isFavorite) {
      await db.insert(DBUtils.favoriteTable, toMap);
    }
  }

  Future<List<Article>> fetchDatabase() async {
    List<Article> articleList = [];
    await db.query(DBUtils.favoriteTable).then((value) {
      for (var element in value) {
        Article article = Article();
        article = getFavoriteNewsObect(article: article, element: element);
        articleList.add(article);
      }
    });
    return articleList;
  }

  Future<bool> isNewsExists(int timestamp) async {
    var result = await db.rawQuery(
        "SELECT * FROM ${DBUtils.favoriteTable} WHERE ${DBUtils.favoriteNewsId} = ? ",
        [timestamp]);
    return result.isNotEmpty;
  }

  Future<void> removeFromFavorite(int timestamp) async {
    var result = await db.rawQuery(
        "DELETE FROM ${DBUtils.favoriteTable} WHERE  ${DBUtils.favoriteNewsId} = ?",
        [timestamp]);
  }

  Article getFavoriteNewsObect(
      {required Map<String, dynamic> element, required Article article}) {
    article.id = element[DBUtils.favoriteId] as int;
    article.content = element[DBUtils.favoriteContent] as String;
    article.description = element[DBUtils.favoriteDescrition] ?? '' as String;
    article.title = element[DBUtils.favoriteTitle] as String;
    article.urlToImage = element[DBUtils.favoriteImage] ?? '' as String;
    article.publishedAt =
        DateTime.fromMillisecondsSinceEpoch(element[DBUtils.favoriteNewsId]);
    article.isFavorite = true;
    return article;
  }
}
