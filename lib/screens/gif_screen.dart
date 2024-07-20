import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpapers_hd/controller/Gif/gif_controller.dart';
import 'package:wallpapers_hd/screens/singlewallpaper.dart';

import '../api_services/home_services.dart';
import '../app_extension/appextension.dart';
import '../app_widget/customwidget.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../modal/wallmodel.dart';

class GifScreen extends StatefulWidget {
  const GifScreen({super.key});

  @override
  State<GifScreen> createState() => _GifScreenState();
}

class _GifScreenState extends State<GifScreen> {
  latestPagination() async {
    if (gifController.latestScrollController.position.pixels == gifController.latestScrollController.position.maxScrollExtent &&
        ((gifController.latestGifList.length) % 9 < (int.parse(gifController.latestGifList.first.num ?? ''))) &&
        ((gifController.latestGifList.length) < (int.parse(gifController.latestGifList.first.num ?? '')))) {
      gifController.latestPage.value++;
      Apis().getLatestGif(Page: gifController.latestPage.value.toString());
    }
  }

  allPagination() async {
    if (gifController.allScrollController.position.pixels == gifController.allScrollController.position.maxScrollExtent &&
        ((gifController.allGifList.length) % 9 < (int.parse(gifController.allGifList.first.num ?? ''))) &&
        ((gifController.allGifList.length) < (int.parse(gifController.allGifList.first.num ?? '')))) {
      gifController.allPage.value++;
      Apis().getAllGif(Page: gifController.allPage.value.toString());
    }
  }

  @override
  void initState() {
    gifController.latestScrollController.addListener(latestPagination);
    gifController.allScrollController.addListener(allPagination);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leadingWidth: 60.w,
          title: TextModel(
            'GIF',
            fontSize: 24.sp,
            fontFamily: 'SB',
            letterSpacing: 1.5,
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: whiteColor,
            tabs: [
              Tab(
                child: TextModel('Latest', fontSize: 20.sp, fontFamily: 'M'),
              ),
              Tab(
                child: TextModel('All', fontSize: 20.sp, fontFamily: 'M'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [LatestGif(), AllGif()]),
      ),
    );
  }

  Widget LatestGif() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
      child: Obx(() {
        return RefreshIndicator(
          backgroundColor: themeColor,
          color: pinkColor,
          onRefresh: () async {
            gifController.latestGifList.clear();
            gifController.latestPage.value = 1;
            Apis().getLatestGif(Page: gifController.latestPage.value.toString());
          },
          child: MasonryGridView.count(
            controller: gifController.latestScrollController,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: gifController.latestGifList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SingleWallpaper(
                      isBottom: true,
                      isPaid: isPaidWallpaper('0'),
                      wallType: 'gif',
                      gif: true,
                      wall: List.generate(gifController.latestGifList.length,
                          (i) => Wall(id: gifController.latestGifList[i].id ?? '', title: gifController.latestGifList[i].gifTags ?? '', image: gifController.latestGifList[i].gifImage ?? '')),
                      index: index));
                },
                child: Container(
                  height: ((index % 3 + 3) * 50).h,
                  decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => commonShimmer(),
                          fit: BoxFit.cover,
                          imageUrl: gifController.latestGifList[index].gifImage ?? '',
                          memCacheHeight: 800,
                        ),
                      ),
                      Positioned(
                          right: commonWidth(context) * 0.010,
                          top: commonHeight(context) * 0.010,
                          child: Container(
                            height: commonHeight(context) * 0.030,
                            width: isTab(context) ? commonWidth(context) * 0.12 : commonWidth(context) * 0.15,
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(
                                  Icons.remove_red_eye_sharp,
                                  size: 20.0.sp,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                TextModel(
                                  formatFollowerCount(int.parse(gifController.latestGifList[index].totalViews ?? '')),
                                  fontSize: 12.0.sp,
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget AllGif() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
      child: Obx(() {
        return RefreshIndicator(
          backgroundColor: themeColor,
          color: pinkColor,
          onRefresh: () async {
            gifController.allGifList.clear();
            gifController.allPage.value = 1;
            Apis().getAllGif(Page: gifController.allPage.value.toString());
          },
          child: MasonryGridView.count(
            controller: gifController.allScrollController,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: gifController.allGifList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SingleWallpaper(
                      isBottom: true,
                      isPaid: isPaidWallpaper('0'),
                      wallType: 'gif',
                      gif: true,
                      wall: List.generate(gifController.allGifList.length,
                          (i) => Wall(id: gifController.allGifList[i].id ?? '', title: gifController.allGifList[i].gifTags ?? '', image: gifController.allGifList[i].gifImage ?? '')),
                      index: index));
                },
                child: Container(
                  height: ((index % 3 + 3) * 50).h,
                  decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => commonShimmer(),
                          imageUrl: gifController.allGifList[index].gifImage ?? '',
                          memCacheHeight: 800,
                        ),
                      ),
                      Positioned(
                          right: commonWidth(context) * 0.010,
                          top: commonHeight(context) * 0.010,
                          child: Container(
                            height: commonHeight(context) * 0.030,
                            width: isTab(context) ? commonWidth(context) * 0.12 : commonWidth(context) * 0.15,
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(
                                  Icons.remove_red_eye_sharp,
                                  size: 20.0.sp,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                TextModel(
                                  formatFollowerCount(int.parse(gifController.allGifList[index].totalViews ?? '')),
                                  fontSize: 12.0.sp,
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
