// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:news_app/src/mvp/dashboard/all_news/view/all_news_screen.dart';
import 'package:news_app/src/mvp/dashboard/favorite/view/favorite_screen.dart';
import 'package:news_app/src/mvp/dashboard/top_headlines/view/top_headline_screen.dart';
import 'package:news_app/utils/utils.dart';

class DashBoardData {
  DashBoardData(
      {required this.selectedIcon,
      required this.unSelectedIcon,
      required this.lable});

  final IconData selectedIcon;
  final IconData unSelectedIcon;
  final String lable;
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int selectedIndex = 0;

  List<DashBoardData> dashboardDataList = [
    DashBoardData(
        unSelectedIcon: Icons.home_outlined,
        selectedIcon: Icons.home,
        lable: 'All'),
    DashBoardData(
        selectedIcon: Icons.access_time_filled,
        unSelectedIcon: Icons.access_time,
        lable: 'Headlines'),
    DashBoardData(
        unSelectedIcon: Icons.favorite_border_rounded,
        selectedIcon: Icons.favorite_outlined,
        lable: 'Fovorite'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.blackColor,
      body: getPages(selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomNavigationBar(
          // landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          // type: BottomNavigationBarType.fixed,
          elevation: 10,
          //
          currentIndex: selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: ColorUtils.blackColor,
          selectedLabelStyle:
              FontUtilities.h14(fontColor: ColorUtils.blackColor),
          unselectedLabelStyle:
              FontUtilities.h14(fontColor: ColorUtils.blackColor),
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: List.generate(
              3,
              (index) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Icon(
                        selectedIndex == index
                            ? dashboardDataList[index].selectedIcon
                            : dashboardDataList[index].unSelectedIcon,
                      ),
                    ),
                    label: dashboardDataList[index].lable,
                  )),
        ),
      ),
    );
  }

  dynamic getPages(int page) {
    switch (page) {
      case 0:
        return const AllNewsScreen();

      case 1:
        return const TopHeadlineScreen();

      case 2:
        return const FavoriteScreen();
    }
  }
}
