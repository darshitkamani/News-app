import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class APIException implements Exception {
  APIException({required this.message});

  final String message;
  showToast() {
    Fluttertoast.showToast(msg: message);
  }
}
