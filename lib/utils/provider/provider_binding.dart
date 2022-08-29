import 'package:news_app/src/mvp/auth/gooogle_login/provider/google_login_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/provider/news_provider.dart';
import 'package:news_app/src/mvp/dashboard/all_news/sort/provider/sort_provider.dart';
import 'package:news_app/src/mvp/dashboard/favorite/provider/favorite_provider.dart';
import 'package:news_app/src/mvp/dashboard/news_detail/provider/news_detail_provider.dart';
import 'package:news_app/src/mvp/dashboard/top_headlines/provider/top_headline_provider.dart';
import 'package:provider/provider.dart';

/// This class manage all the provider and return list of provider.
class ProviderBind {
  /// This is the list of providers to manage and attache with application.
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<GoogleLoginProvider>(
        create: (_) => GoogleLoginProvider()),
    ChangeNotifierProvider<NewsProvider>(create: (_) => NewsProvider()),
    ChangeNotifierProvider<SortNewsProvider>(create: (_) => SortNewsProvider()),
    ChangeNotifierProvider<FavoriteProvider>(create: (_) => FavoriteProvider()),
    ChangeNotifierProvider<TopHeadlineProvider>(
        create: (_) => TopHeadlineProvider()),
    ChangeNotifierProvider<NewsDetailsProvider>(
        create: (_) => NewsDetailsProvider()),
  ];
}
