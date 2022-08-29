import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';

class SortNewsArgs {
  final String sortBy;
  final NewsType newsType;

  SortNewsArgs({required this.sortBy, required this.newsType});
}
