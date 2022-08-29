import 'package:fluttertoast/fluttertoast.dart';

class PageNotFoundException implements Exception {
  PageNotFoundException({this.message});

  final String? message;
  showToast() {
    Fluttertoast.showToast(msg: message ?? 'Page not found!');
  }
}
