// ignore_for_file: avoid_print, prefer_single_quotes, public_member_api_docs

import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/mvp/dashboard/all_news/model/news_response.dart';
import 'package:news_app/utils/utils.dart';

Future<Either<NewsResponse, Exception>> fetchAllNewsApi(BuildContext context,
    {required String page}) async {
  Either<dynamic, Exception> data = await API.callAPI(context,
      url: APIUtilities.allNewsBaseUrl,
      type: APIType.tGet,
      parameters: {'page': page, 'pageSize': '20', 'domains': 'aajtak.in'});
  if (data.isLeft) {
    try {
      return Left(NewsResponse.fromJson(jsonDecode(jsonEncode(data.left))));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(data.right);
  }
}
