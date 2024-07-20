import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/app_widget/customwidget.dart';

import 'package:wallpapers_hd/screens/home/populer/popular_see_all.dart';
import 'package:wallpapers_hd/screens/home/populer/populer_wallpaper_list.dart';

import '../../admob/ads_manager.dart';
import '../../api_services/home_services.dart';
import '../../app_extension/appextension.dart';
import '../../constant.dart';
import '../../controller/home/homecontroller.dart';
import '../../modal/wallmodel.dart';
import '../../res.dart';
import '../../subscription/subscription.dart';
import '../singlewallpaper.dart';

class HomeTab extends StatefulWidget {
  final ImageOrientation selectedItem;
  const HomeTab({super.key, required this.selectedItem});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dataKey = new GlobalKey();
  RxInt page = 1.obs;
  ScrollController _scrollController = ScrollController();
  late RxBool _isVisible;

  pagination() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        homeController.getWallPaperList.isNotEmpty &&
        ((homeController.getWallPaperList.length) % 9 < (int.parse(homeController.getWallPaperList.first.num ?? ''))) &&
        ((homeController.getWallPaperList.length) < (int.parse(homeController.getWallPaperList.first.num ?? '')))) {
      page.value++;
      print('page value :: ${page.value}');
      Apis().getWallpaper(Page: '${page.value}');
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
            padding: EdgeInsets.only(top: isTab(context) ? 165.h : 145.0.h),
            child: Visibility(
                visible: _isVisible.value,
                child: FloatingActionButton(
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  backgroundColor: themeColor.withOpacity(0.7),
                  onPressed: () {
                    Scrollable.ensureVisible(dataKey.currentContext!, duration: Duration(milliseconds: 800));
                    _scrollController.position.animateTo(0, duration: Duration(milliseconds: 600), curve: Curves.linear);
                  },
                  child: Icon(Icons.arrow_upward),
                )),
          );
        }),
      ),
      body: RefreshIndicator(
        backgroundColor: themeColor,
        color: pinkColor,
        onRefresh: () async {
          homeController.wallpaperColors.clear();
          homeController.featuredWallpaper.clear();
          homeController.latestWallpaper.clear();
          homeController.popularWallpaper.clear();
          homeController.getWallPaperList.clear();
          homeController.getPopularSectionList.clear();
          page.value = 1;
          Apis().getWallpaper(
            Page: page.value.toString(),
          );
          Apis().getPopularSection(Page: page.value.toString());
          Apis().getHomeApi(Page: page.value.toString(), type: widget.selectedItem);
        },
        child: homeController.getWallPaperList.isEmpty || homeController.featuredWallpaper.isEmpty || homeController.getPopularSectionList.isEmpty
            ? SizedBox(
                height: commonHeight(context),
                width: commonWidth(context),
                child: Center(
                  child: CircularProgressIndicator(
                    color: pinkColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                key: dataKey,
                controller: _scrollController,
                child: Obx(() {
                  return Column(
                    children: [
                      homeController.featuredWallpaper.isNotEmpty ? FeaturedWallpaper() : SizedBox(),
                      homeController.getPopularSectionList.isNotEmpty ? PopularCollection() : SizedBox(),
                      isSubscribe.value == false
                          ? SizedBox(
                              height: 5.0.h,
                            )
                          : SizedBox(),
                      isSubscribe.value == false || Platform.isAndroid ? bannerAds() : SizedBox.shrink(),
                      homeController.latestWallpaper.isNotEmpty ? TrendingWallpaper() : SizedBox(),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      homeController.popularWallpaper.isNotEmpty ? PopularWallpaper() : SizedBox(),
                      isSubscribe.value == false
                          ? SizedBox(
                              height: 15.0.h,
                            )
                          : SizedBox(),
                      // isSubscribe.value == false || Platform.isAndroid ? AdmobAds().bannerAds() : SizedBox(),
                      homeController.getWallPaperList.isNotEmpty ? LatestWallpaper() : SizedBox(),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  );
                })),
      ),
    );
  }

  Widget FeaturedWallpaper() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          TextModel(
            'Featured',
            fontSize: 20.0,
            letterSpacing: 0.5,
            fontFamily: 'SB',
          ),
          SizedBox(
            height: 10.0,
          ),
          Obx(() {
            if (homeController.featuredWallpaper.isNotEmpty) {
              return SizedBox(
                height: 210.h,
                width: commonWidth(context),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: homeController.featuredWallpaper.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => SingleWallpaper(
                              isBottom: true,
                              isPaid: isPaidWallpaper(homeController.featuredWallpaper[index].isPaid ?? ''),
                              wallType: 'home',
                              wall: List.generate(
                                  homeController.featuredWallpaper.length,
                                  (i) => Wall(
                                      id: homeController.featuredWallpaper[i].id ?? '',
                                      title: homeController.featuredWallpaper[i].wallTags ?? '',
                                      image: homeController.featuredWallpaper[i].wallpaperImage ?? '')),
                              index: index));
                        },
                        child: Container(
                          width: 110.w,
                          decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => commonShimmer(),
                                  imageUrl: homeController.featuredWallpaper[index].wallpaperImage ?? '',
                                  memCacheHeight: 700,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  right: commonWidth(context) * 0.010,
                                  top: commonHeight(context) * 0.010,
                                  child: Row(
                                    children: [
                                      Container(
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
                                              formatFollowerCount(int.parse(homeController.featuredWallpaper[index].totalViews ?? '')),
                                              fontSize: 12.0.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      homeController.featuredWallpaper[index].isPaid == '1'
                                          ? SizedBox(
                                              height: 30.h,
                                              width: 30.w,
                                              child: SvgPicture.asset(
                                                Res.premium,
                                                colorFilter: ColorFilter.mode(goldenColor, BlendMode.srcIn),
                                              ))
                                          : SizedBox(),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget PopularCollection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              TextModel(
                'Popular Collection',
                fontSize: 20.0,
                letterSpacing: 0.5,
                fontFamily: 'SB',
              ),
              TextModel(
                '🔥',
                fontSize: 15.0,
                letterSpacing: 0.5,
                fontFamily: 'SB',
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => PopularSeeAll(), duration: Duration(milliseconds: 600));
                },
                child: TextModel(
                  'See More',
                  fontSize: 16.0,
                  // letterSpacing: 0.5,
                  color: pinkColor,
                  fontFamily: 'M',
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Obx(() {
            if (homeController.getPopularSectionList.isNotEmpty) {
              return SizedBox(
                height: 181.h,
                width: commonWidth(context),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: homeController.getPopularSectionList.length <= 10 ? homeController.getPopularSectionList.length : 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 5.w, top: 2.h, bottom: 2.h, left: 5.0.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                              () => PopularWallpaperList(
                                    id: homeController.getPopularSectionList[index].id ?? '',
                                    image: homeController.getPopularSectionList[index].popularImage ?? '',
                                    name: homeController.getPopularSectionList[index].popularName ?? '',
                                  ),
                              duration: Duration(milliseconds: 600));
                        },
                        child: StreamBuilder(
                            stream:
                                getDominantColorStreamFromCachedNetworkImage(CachedNetworkImageProvider(maxHeight: 300, maxWidth: 300, homeController.getPopularSectionList[index].popularImage ?? '')),
                            builder: (context, s) {
                              return Hero(
                                tag: homeController.getPopularSectionList[index].popularImage ?? '',
                                child: Container(
                                  width: 105.w,
                                  height: 179.h,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: List.generate(1, (index) => BoxShadow(color: s.data?.vibrantColor?.color ?? whiteColor, blurStyle: BlurStyle.outer, blurRadius: 6)),
                                    border: Border.all(color: s.data?.vibrantColor?.color ?? whiteColor, style: BorderStyle.solid, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) => commonShimmer(),
                                          imageUrl: homeController.getPopularSectionList[index].popularImage ?? '',
                                          memCacheHeight: 700,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10.0,
                                        right: 5.0,
                                        left: 5.0,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: TextModel(
                                            homeController.getPopularSectionList[index].popularName ?? '',
                                            fontSize: 15.0,
                                            maxLines: 3,
                                            color: whiteColor,
                                            fontFamily: 'SB',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget TrendingWallpaper() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          TextModel(
            'Trending',
            fontSize: 20.0,
            letterSpacing: 0.5,
            fontFamily: 'SB',
          ),
          SizedBox(
            height: 15.0,
          ),
          Obx(() {
            if (homeController.latestWallpaper.isNotEmpty) {
              return MasonryGridView.count(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                itemCount: homeController.latestWallpaper.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SingleWallpaper(
                          isBottom: true,
                          isPaid: isPaidWallpaper(homeController.latestWallpaper[index].isPaid ?? ''),
                          wallType: 'home',
                          wall: List.generate(
                              homeController.latestWallpaper.length,
                              (i) => Wall(
                                  id: homeController.latestWallpaper[i].id ?? '',
                                  title: homeController.latestWallpaper[i].wallTags ?? '',
                                  image: homeController.latestWallpaper[i].wallpaperImage ?? '')),
                          index: index));
                    },
                    child: Container(
                      height: 230.h,
                      decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => commonShimmer(),
                              imageUrl: homeController.latestWallpaper[index].wallpaperImage ?? '',
                              memCacheHeight: 700,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              right: commonWidth(context) * 0.010,
                              top: commonHeight(context) * 0.010,
                              child: Row(
                                children: [
                                  Container(
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
                                          formatFollowerCount(int.parse(homeController.latestWallpaper[index].totalViews ?? '')),
                                          fontSize: 12.0.sp,
                                        )
                                      ],
                                    ),
                                  ),
                                  homeController.latestWallpaper[index].isPaid == '1'
                                      ? SizedBox(
                                          height: 30.h,
                                          width: 30.w,
                                          child: SvgPicture.asset(
                                            Res.premium,
                                            colorFilter: ColorFilter.mode(goldenColor, BlendMode.srcIn),
                                          ))
                                      : SizedBox(),
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
    );
  }

  Widget PopularWallpaper() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          TextModel(
            'Popular',
            fontSize: 20.0,
            letterSpacing: 0.5,
            fontFamily: 'SB',
          ),
          SizedBox(
            height: 15.0,
          ),
          Obx(() {
            if (homeController.popularWallpaper.isNotEmpty) {
              return MasonryGridView.count(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                itemCount: homeController.popularWallpaper.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SingleWallpaper(
                          isBottom: true,
                          isPaid: isPaidWallpaper(homeController.popularWallpaper[index].isPaid ?? ''),
                          wallType: 'home',
                          wall: List.generate(
                              homeController.popularWallpaper.length,
                              (i) => Wall(
                                  id: homeController.popularWallpaper[i].id ?? '',
                                  title: homeController.popularWallpaper[i].wallTags ?? '',
                                  image: homeController.popularWallpaper[i].wallpaperImage ?? '')),
                          index: index));
                    },
                    child: Container(
                      height: 230.0.h,
                      decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => commonShimmer(),
                              imageUrl: homeController.popularWallpaper[index].wallpaperImage ?? '',
                              memCacheHeight: 700,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              right: commonWidth(context) * 0.010,
                              top: commonHeight(context) * 0.010,
                              child: Row(
                                children: [
                                  Container(
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
                                          formatFollowerCount(int.parse(homeController.popularWallpaper[index].totalViews ?? '')),
                                          fontSize: 12.0.sp,
                                        )
                                      ],
                                    ),
                                  ),
                                  homeController.popularWallpaper[index].isPaid == '1'
                                      ? SizedBox(
                                          height: 30.h,
                                          width: 30.w,
                                          child: SvgPicture.asset(
                                            Res.premium,
                                            colorFilter: ColorFilter.mode(goldenColor, BlendMode.srcIn),
                                          ))
                                      : SizedBox(),
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget LatestWallpaper() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextModel(
                'Latest',
                fontSize: 20.0.sp,
                letterSpacing: 0.5,
                fontFamily: 'SB',
              ),
              Spacer(),
              // TextButton(
              //   onPressed: () {
              //     Get.to(() => LatestSeeMoreScreen());
              //   },
              //   child: TextModel(
              //     'See More',
              //     fontSize: 16.0,
              //     color: pinkColor,
              //     fontFamily: 'M',
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          MasonryGridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            itemCount: homeController.getWallPaperList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SingleWallpaper(
                      isBottom: true,
                      isPaid: isPaidWallpaper(homeController.getWallPaperList[index].isPaid ?? ''),
                      wallType: 'home',
                      wall: List.generate(
                          homeController.getWallPaperList.length,
                          (i) => Wall(
                              id: homeController.getWallPaperList[i].id ?? '',
                              title: homeController.getWallPaperList[i].wallTags ?? '',
                              image: homeController.getWallPaperList[i].wallpaperImage ?? '')),
                      index: index));
                },
                child: Container(
                  height: isTab(context) ? 300.h : 230.h,
                  decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => commonShimmer(),
                          fit: BoxFit.cover,
                          imageUrl: homeController.getWallPaperList[index].wallpaperImage ?? '',
                          memCacheHeight: 700,
                        ),
                      ),
                      Positioned(
                          right: commonWidth(context) * 0.010,
                          top: commonHeight(context) * 0.010,
                          child: Row(
                            children: [
                              Container(
                                height: commonHeight(context) * 0.030,
                                width: isTab(context) ? commonWidth(context) * 0.12 : commonWidth(context) * 0.15,
                                decoration: BoxDecoration(color: themeColor.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      formatFollowerCount(int.parse(homeController.getWallPaperList[index].totalViews ?? '')),
                                      fontSize: 12.0.sp,
                                    )
                                  ],
                                ),
                              ),
                              homeController.getWallPaperList[index].isPaid == '1'
                                  ? SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: SvgPicture.asset(
                                        Res.premium,
                                        colorFilter: ColorFilter.mode(goldenColor, BlendMode.srcIn),
                                      ))
                                  : SizedBox(),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
