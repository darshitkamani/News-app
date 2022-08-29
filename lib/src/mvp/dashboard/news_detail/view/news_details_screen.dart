import 'package:flutter/material.dart';
import 'package:news_app/src/mvp/dashboard/news_detail/provider/news_detail_provider.dart';
import 'package:news_app/src/widgets/image/images.dart';
import 'package:news_app/utils/assets/assetss_utils.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:news_app/src/mvp/dashboard/all_news/args/news_details_args.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsDetailsArg newsDetailsArg;
  const NewsDetailsScreen({Key? key, required this.newsDetailsArg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<NewsDetailsProvider>(
            builder: (_, NewsDetailsProvider newsDetailsProvider, __) {
          return SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    (newsDetailsArg.article!.urlToImage == null ||
                            newsDetailsArg.article!.urlToImage!.isEmpty)
                        ? const CustomImageView(
                            imageUrl: AssetUtilities.newsAppLogo)
                        : CustomCachedNetworkImageView(
                            imageUrl: newsDetailsArg.article!.urlToImage!,
                            height: screenSize.height * 0.30,
                            width: screenSize.width,
                            boxFit: BoxFit.cover,
                          ),
                    // Image(
                    //   image: NetworkImage(newsDetailsArg.article!.urlToImage!),
                    //   height: screenSize.height * 0.30,
                    //   width: screenSize.width,
                    //   fit: BoxFit.cover,
                    // ),
                    SizedBox(
                      height: screenSize.height * 0.30,
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30, left: 10),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white)),
                            ),
                          ),
                          Container(
                            color: ColorUtils.whiteColor,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timeago.format(
                                        newsDetailsArg.article!.publishedAt!),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        newsDetailsProvider
                                            .checkHeadlineIsFavorite(
                                                newsDetailsArg.article!);
                                      },
                                      icon: (newsDetailsArg
                                                      .article!.isFavorite ??
                                                  false) ==
                                              true
                                          ? const Icon(
                                              Icons.bookmark,
                                              color: ColorUtils.blackColor,
                                            )
                                          : const Icon(Icons.bookmark_border,
                                              color: ColorUtils.blackColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 05,
                            height: 60,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              newsDetailsArg.article!.title ?? '',
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        newsDetailsArg.article!.description ?? '',
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        newsDetailsArg.article!.content ?? '',
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
