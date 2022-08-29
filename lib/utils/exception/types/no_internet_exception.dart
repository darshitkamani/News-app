import 'package:flutter/material.dart';
import 'package:news_app/utils/utils.dart';

class NoInternetException implements Exception {
  NoInternetException();
  final String _title = '''No Internet!''';
  final String _message =
      '''You are not Connected to the internet\nPlease turn your internet connection on and try again.''';

  String getMessage() => _message;

  void showNoNetworkWidget(
      {required BuildContext context,
      required VoidCallback onCancelTap,
      required VoidCallback onRetryTap}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(_title),
            content: Text('No Internet',
                style: FontUtilities.h14(fontColor: ColorUtils.blackColor)),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(onPressed: onCancelTap, child: const Text('Cancel')),
              //    ignore: deprecated_member_use
              FlatButton(onPressed: onRetryTap, child: const Text('Retry'))
            ],
          );
        });
  }
}
