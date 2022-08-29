import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/utils/utils.dart';

enum APIType {
  tPost,
  tGet,
  tPut,
}

class API {
  static Future<Either<dynamic, Exception>> callAPI(
    BuildContext context, {
    required String url,
    required APIType type,
    Map<String, dynamic>? body,
    Map<String, String>? header,
    Map<String, dynamic>? parameters,
  }) async {
    List<String>? listKeys = [];
    List<String>? listValues = [];

    if (parameters != null) {
      parameters.forEach((key, value) {
        listKeys.add(key);
        listValues.add(value);
      });
    }

    String? paramString = '';
    for (int i = 0; i < listKeys.length; i++) {
      if (i == 0) {
        paramString = '${paramString!}?';
      }
      paramString = '${paramString!}${listKeys[i]}=${listValues[i]}';

      if (i != listKeys.length - 1) {
        paramString = '$paramString&';
      }
    }
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        http.Response apiResponse;
        dynamic apiBody = body;

        Map<String, String> appHeader = {};
        appHeader.addAll({
          'Content-type': 'application/json',
          'X-Api-Key': 'ab62dd35497545a19ef6cb82be9eebe1'
        });

        if (header != null) {
          appHeader.addAll(header);
        }

        if (type == APIType.tPost) {
          apiResponse = await http.post(
            Uri.parse(url),
            body: apiBody,
            headers: appHeader,
          );
        } else {
          apiResponse = await http.get(
            Uri.parse(url + paramString!),
            headers: appHeader,
          );
        }
        late Map<String, dynamic> response;
        response = jsonDecode(apiResponse.body);
        switch (apiResponse.statusCode) {
          case 200:
            return Left(response);

          case 500:
            ServerException().showToast();
            return Right(ServerException());

          case 404: // page not found !

            PageNotFoundException().showToast();
            return Right(PageNotFoundException());
          case 400: // bad request !

            BadRequestException().showToast();
            return Right(BadRequestException());

          default:
            GeneralAPIException().showToast();
            return Right(GeneralAPIException());
        }
      } catch (e) {
        APIException(message: e.toString()).showToast();
        return Right(
          APIException(
            message: e.toString(),
          ),
        );
      }
    } else {
      NoInternetException();
      return Right(
        NoInternetException(),
      );
    }
  }
}
