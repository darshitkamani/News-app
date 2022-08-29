import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All the global variables used in the application are defined in this class.
class VariableUtilities {
  /// we can use screensize in application using this global variable.
  static late Size screenSize;

  /// this is the instance of shared pr eferences.
  /// this will be used to access preference instance in application.
  static late SharedPreferences preferences;
}
