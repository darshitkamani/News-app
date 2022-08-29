import 'package:fluttertoast/fluttertoast.dart';

class ServerException implements Exception {
  ServerException({this.message});

  final String? message;
  showToast() {
    Fluttertoast.showToast(msg: message ?? 'Server Exception!');
  }
}
