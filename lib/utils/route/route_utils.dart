import 'package:flutter/material.dart';
import 'package:news_app/src/mvp/auth/gooogle_login/view/google_login_screen.dart';
import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/args/sort_news_args.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/view/sort_screen.dart';
import 'package:news_app/src/mvp/dashboard/all_news/view/all_news_screen.dart';
import 'package:news_app/src/mvp/dashboard/news_detail/view/news_details_screen.dart';
import 'package:news_app/src/mvp/dashboard/dashboard/view/dashborad_screen.dart';
import 'package:news_app/src/mvp/splash/view/splash_screen.dart';

/// Manage all the routes used in the application.
class RouteUtilities {
  /// first screen to open in the application.
  static const String root = '/';
  static const String googleLoginScreen = '/googleLoginScreen';
  static const String allNewsScreen = '/allNewsScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String sortNewsScreen = '/sortNewsScreen';
  static const String newsDetailsScreen = '/newsDetailsScreen';

  /// we are using named route to navigate to another screen,
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    String routeName = settings.name ?? RouteUtilities.root;

    /// this is the instance of arguements to pass data in other screens.
    dynamic arguements = settings.arguments;
    switch (routeName) {
      case RouteUtilities.root:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RouteUtilities.googleLoginScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const GoogleLoginScreen(),
        );
      case RouteUtilities.allNewsScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AllNewsScreen(),
        );
      case RouteUtilities.dashboardScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const DashBoardScreen(),
        );
      case RouteUtilities.sortNewsScreen:
        var sortNewsArgs = (settings.arguments is SortNewsArgs)
            ? settings.arguments as SortNewsArgs
            : null;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              SortNewsScreen(sortNewsArgs: sortNewsArgs as SortNewsArgs),
        );
      case RouteUtilities.newsDetailsScreen:
        var newsDetailsArg = (settings.arguments is NewsDetailsArg)
            ? settings.arguments as NewsDetailsArg
            : null;
        return MaterialPageRoute(
          builder: (BuildContext context) => NewsDetailsScreen(
              newsDetailsArg: newsDetailsArg as NewsDetailsArg),
        );
    }
  }
}
