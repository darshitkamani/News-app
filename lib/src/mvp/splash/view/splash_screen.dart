import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/src/widgets/widgets.dart';
import 'package:news_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  /// Start Timer...
  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      timer.cancel();
      bool isLogin = VariableUtilities.preferences
              .getBool(LocalCacheKey.applicationLoginState) ??
          false;

      if (isLogin) {
        Navigator.pushReplacementNamed(context, RouteUtilities.dashboardScreen);
      } else {
        Navigator.pushReplacementNamed(
            context, RouteUtilities.googleLoginScreen);
      }
    });
  }

  Future<void> initializeSettings() async {
    /// Settings Instance of SharedPreferences.
    VariableUtilities.preferences = await SharedPreferences.getInstance();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    VariableUtilities.screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: ColorUtils.whiteColor,
      height: VariableUtilities.screenSize.height,
      width: VariableUtilities.screenSize.width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomImageView(
                      imageUrl: AssetUtilities.newsAppLogo,
                      height: 200,
                    ),
                  ]),
            ),
            Text(
              '24/7 News',
              style: FontUtilities.h23(
                  fontColor: ColorUtils.blackColor, fontWeight: FWT.bold),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    ));
  }
}
