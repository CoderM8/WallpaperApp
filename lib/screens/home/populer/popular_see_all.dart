import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/screens/home/populer/populer_wallpaper_list.dart';
import 'package:wallpapers_hd/screens/no_internet.dart';

import '../../../api_services/home_services.dart';
import '../../../app_extension/appextension.dart';
import '../../../app_widget/customwidget.dart';
import '../../../controller/home/homecontroller.dart';
import '../../bottomscreen/bottomscreen.dart';

class PopularSeeAll extends StatefulWidget {
  const PopularSeeAll({super.key});

  @override
  State<PopularSeeAll> createState() => _PopularSeeAllState();
}

class _PopularSeeAllState extends State<PopularSeeAll> {
  RxInt page = 1.obs;
  final dataKey = new GlobalKey();

  late RxBool _isVisible;
  ScrollController _scrollController = ScrollController();

  pagination() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        ((homeController.getPopularSectionList.length) % 9 < (int.parse(homeController.getPopularSectionList.first.num ?? ''))) &&
        ((homeController.getPopularSectionList.length) < (int.parse(homeController.getPopularSectionList.first.num ?? '')))) {
      page.value++;
      print('page value :: ${page.value}');
      Apis().getPopularSection(Page: page.value.toString());
    }
  }

  @override
  void initState() {
    _scrollController.addListener(pagination);
    _isVisible = false.obs;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 100) {
        _isVisible.value = false;
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible == true) {
          _isVisible.value = false;
        }
      } else {
        if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (_isVisible == false) {
            _isVisible.value = true;
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      floatingActionButton: Container(
        height: 200.h,
        child: Obx(() {
          return Padding(
            padding: EdgeInsets.only(top: isTab(context) ? 165.h : 145.h),
            child: new Visibility(
                visible: _isVisible.value,
                child: new FloatingActionButton(
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  backgroundColor: themeColor.withOpacity(0.7),
                  onPressed: () {
                    _isVisible.value = false;
                    // Scrollable.ensureVisible(dataKey.currentContext!, duration: Duration(milliseconds: 600));
                    _scrollController.position.animateTo(0, duration: Duration(milliseconds: 600), curve: Curves.linear);
                  },
                  child: Icon(Icons.arrow_upward),
                )),
          );
        }),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: whiteColor),
        title: Row(
          children: [
            TextModel(
              'Popular Collection',
              fontSize: 20.0,
              fontFamily: 'SB',
            ),
            TextModel(
              '🔥',
              fontSize: 15.0,
              letterSpacing: 0.5,
              fontFamily: 'SB',
            )
          ],
        ),
      ),
      body: Obx(() {
        if (internetController.connectionType.value == 1 || internetController.connectionType.value == 2 || internetController.connectionType.value == 3) {
          return RefreshIndicator(
            backgroundColor: themeColor,
            color: pinkColor,
            onRefresh: () async {
              homeController.getPopularSectionList.clear();
              page.value = 1;
              Apis().getPopularSection(Page: page.value.toString());
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: homeController.getPopularSectionList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                        () => PopularWallpaperList(
                            image: homeController.getPopularSectionList[index].popularImage ?? '',
                            id: homeController.getPopularSectionList[index].id ?? '',
                            name: homeController.getPopularSectionList[index].popularName ?? ''),
                        duration: Duration(milliseconds: 600));
                  },
                  /*child: ListTile(
                  visualDensity: VisualDensity(vertical: 4),
                  contentPadding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 20.0.sp),
                  title: TextModel(
                    homeController.getPopularSectionList[index].popularName ?? '',
                    fontSize: 16.0,
                    fontFamily: 'SB',
                    color: whiteColor,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: whiteColor.withOpacity(0.7),
                        size: 14,
                      ),
                      TextModel(
                        homeController.getPopularSectionList[index].wallCount ?? '',
                        fontSize: 14.0,
                        fontFamily: 'SB',
                        color: whiteColor,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  leading: StreamBuilder(
                      stream: getDominantColorStreamFromCachedNetworkImage(CachedNetworkImageProvider(maxHeight: 300, maxWidth: 300, homeController.getPopularSectionList[index].popularImage ?? '')),
                      builder: (context, s) {
                        return Container(
                          width: 50.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: List.generate(1, (index) => BoxShadow(color: s.data?.vibrantColor?.color ?? whiteColor, blurStyle: BlurStyle.outer, blurRadius: 6)),
                            border: Border.all(color: s.data?.vibrantColor?.color ?? whiteColor, style: BorderStyle.solid, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Hero(
                              transitionOnUserGestures: false,
                              tag: homeController.getPopularSectionList[index].popularImage ?? '',
                              child: CachedNetworkImage(
                                placeholder: (context, url) => commonShimmer(),
                                imageUrl: homeController.getPopularSectionList[index].popularImage ?? '',
                                memCacheHeight: 400,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                ),*/
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 120.0.h,
                          width: 70.w,
                          child: StreamBuilder(
                              stream: getDominantColorStreamFromCachedNetworkImage(
                                  CachedNetworkImageProvider(maxHeight: 300, maxWidth: 300, homeController.getPopularSectionList[index].popularImage ?? '')),
                              builder: (context, s) {
                                return Container(
                                  width: 50.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: List.generate(1, (index) => BoxShadow(color: s.data?.vibrantColor?.color ?? whiteColor, blurStyle: BlurStyle.outer, blurRadius: 6)),
                                    border: Border.all(color: s.data?.vibrantColor?.color ?? whiteColor, style: BorderStyle.solid, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Hero(
                                      transitionOnUserGestures: false,
                                      tag: homeController.getPopularSectionList[index].popularImage ?? '',
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => commonShimmer(),
                                        imageUrl: homeController.getPopularSectionList[index].popularImage ?? '',
                                        memCacheHeight: 700,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 230.w,
                              child: TextModel(
                                homeController.getPopularSectionList[index].popularName ?? '',
                                fontSize: 20.0,
                                fontFamily: 'SB',
                                color: whiteColor,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.photo_library_outlined,
                                  color: whiteColor.withOpacity(0.7),
                                  size: 16.sp,
                                ),
                                TextModel(
                                  homeController.getPopularSectionList[index].wallCount ?? '',
                                  fontSize: 16.0,
                                  fontFamily: 'SB',
                                  color: whiteColor,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 30.0.sp,
                      ),
                      SizedBox(
                        width: 20.0.w,
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
        return NoInternetScreen();
      }),
    );
  }
}
