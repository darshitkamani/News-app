import 'package:flutter/material.dart';
import 'package:news_app/src/widgets/image/images.dart';
import 'package:news_app/utils/database/favorite_database.dart';
import 'package:news_app/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsView extends StatefulWidget {
  final String newsHeadline;
  final String? imageURL;
  final DateTime timeStamp;
  final VoidCallback onBookmarkTap;
  final VoidCallback onTap;
  bool? isFavorite;
  NewsView({
    Key? key,
    required this.newsHeadline,
    this.isFavorite = false,
    required this.imageURL,
    required this.timeStamp,
    required this.onTap,
    required this.onBookmarkTap,
  }) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  void initState() {
    // if (widget.isFavorite!) {
    // }
    super.initState();
  }

  bool isNewsFavorite(DateTime dateTime) {
    bool isExists = false;
    checkFavorite(dateTime).then((value) {
      isExists = value;
      // setState(() {});
    });
    return isExists;
  }

  Future<bool> checkFavorite(DateTime dateTime) async {
    bool isExists = false;
    isExists = await Favorite().isNewsExists(dateTime.millisecondsSinceEpoch);
    return isExists;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 25, top: 10),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: Colors.transparent,
          height: 100,
          width: VariableUtilities.screenSize.width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF242424),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      height: 100,
                      // width: VariableUtilities.screenSize.width,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 100,
                              width: 90),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.newsHeadline,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        timeago.format(widget.timeStamp),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: widget.onBookmarkTap,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              color: Colors.transparent,
                                              child: (widget.isFavorite ??
                                                          false) ==
                                                      true
                                                  ? const Icon(
                                                      Icons.bookmark,
                                                      color:
                                                          ColorUtils.whiteColor,
                                                    )
                                                  : const Icon(
                                                      Icons.bookmark_border,
                                                      color: ColorUtils
                                                          .whiteColor))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -13,
                left: -13,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (widget.imageURL == null || widget.imageURL!.isEmpty)
                        ? Image.asset(AssetUtilities.newsAppLogo)
                        : CustomCachedNetworkImageView(
                            imageUrl: widget.imageURL!, boxFit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
