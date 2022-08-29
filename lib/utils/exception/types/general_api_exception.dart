import 'package:fluttertoast/fluttertoast.dart';

class GeneralAPIException implements Exception {
  final String _message =
      '''Something is missing in request.\nPlease check your request and try again!''';
  showToast() {
    Fluttertoast.showToast(msg: _message);
  }
}
