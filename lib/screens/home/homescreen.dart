import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/home/homecontroller.dart';
import 'package:wallpapers_hd/screens/home/premium_tab.dart';

import '../../api_services/home_services.dart';
import 'category_tab.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  RxInt page = 1.obs;
  RxInt currentTab = 0.obs;
  ImageOrientation? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: currentTab.value,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextModel('HD Wallpaper', fontSize: 20.sp, fontFamily: 'M'),
          actions: [
            Obx(() {
              return currentTab.value == 0
                  ? PopupMenuButton<ImageOrientation>(
                      color: themeColor,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      iconColor: whiteColor,
                      initialValue: selectedItem,
                      onSelected: (ImageOrientation item) async {
                        homeController.wallpaperColors.clear();
                        homeController.featuredWallpaper.clear();
                        homeController.latestWallpaper.clear();
                        homeController.popularWallpaper.clear();

                        page.value = 1;
                        selectedItem = item;

                        await Apis().getHomeApi(Page: page.value.toString(), type: item).whenComplete(() {
                          setState(() {});
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<ImageOrientation>>[
                        PopupMenuItem<ImageOrientation>(
                          value: ImageOrientation.All,
                          child: TextModel(
                            'All',
                            color: whiteColor,
                            fontSize: 14.0.sp,
                          ),
                        ),
                        PopupMenuItem<ImageOrientation>(
                          value: ImageOrientation.Portrait,
                          child: TextModel(
                            orientationStringMap[ImageOrientation.Portrait].toString(),
                            color: whiteColor,
                            fontSize: 14.0,
                            fontFamily: 'M',
                          ),
                        ),
                        PopupMenuItem<ImageOrientation>(
                          value: ImageOrientation.Landscape,
                          child: TextModel(
                            orientationStringMap[ImageOrientation.Landscape].toString(),
                            color: whiteColor,
                            fontSize: 14.0,
                            fontFamily: 'M',
                          ),
                        ),
                        PopupMenuItem<ImageOrientation>(
                          value: ImageOrientation.Square,
                          child: TextModel(
                            orientationStringMap[ImageOrientation.Square].toString(),
                            color: whiteColor,
                            fontSize: 14.0,
                            fontFamily: 'M',
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink();
            })
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: whiteColor,
            onTap: (value) {
              currentTab.value = value;
            },
            tabs: [
              Tab(
                child: TextModel('HOME', fontSize: 16.sp, fontFamily: 'M'),
              ),
              Tab(
                child: TextModel('CATEGORY', fontSize: 16.sp, fontFamily: 'M'),
              ),
              Tab(
                child: TextModel('PREMIUM', fontSize: 16.sp, fontFamily: 'M'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: commonHeight(context) * .008),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              /// ======== home tab ========
              HomeTab(selectedItem: selectedItem ?? ImageOrientation.All),

              /// ======== cat tab ========
              CategoryTab(),

              /// ======== Premium tab ========
              PremiumTab()
            ],
          ),
        ),
      ),
    );
  }
}
