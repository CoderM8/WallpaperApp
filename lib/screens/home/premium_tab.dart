import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../api_services/home_services.dart';
import '../../app_extension/appextension.dart';
import '../../app_widget/customwidget.dart';
import '../../constant.dart';
import '../../controller/home/homecontroller.dart';
import '../../modal/wallmodel.dart';
import '../../res.dart';
import '../singlewallpaper.dart';

class PremiumTab extends StatefulWidget {
  const PremiumTab({super.key});

  @override
  State<PremiumTab> createState() => _PremiumTabState();
}

class _PremiumTabState extends State<PremiumTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Premium(),
    );
  }
}

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  RxInt page = 1.obs;
  final dataKey = new GlobalKey();

  late RxBool _isVisible;
  ScrollController _scrollController = ScrollController();

  pagination() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        ((homeController.getPremiumWallpaperList.length) % 9 < (int.parse(homeController.getPremiumWallpaperList.first.num ?? ''))) &&
        ((homeController.getPremiumWallpaperList.length) < (int.parse(homeController.getPremiumWallpaperList.first.num ?? '')))) {
      page.value++;
      print('page value :: ${page.value}');
      Apis().get_premium_list(Page: page.value.toString(), id: '');
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
                    Scrollable.ensureVisible(dataKey.currentContext!, duration: Duration(milliseconds: 600));
                    _scrollController.position.animateTo(0, duration: Duration(milliseconds: 600), curve: Curves.linear);
                  },
                  child: Icon(Icons.arrow_upward),
                )),
          );
        }),
      ),
      body: Obx(() {
        if (isLoadingGetWallpapers.value == true) {
          return SizedBox(
              height: commonHeight(context),
              width: commonWidth(context),
              child: Center(
                  child: CircularProgressIndicator(
                color: pinkColor,
              )));
        } else if (homeController.getPremiumWallpaperList.isNotEmpty) {
          return RefreshIndicator(
            color: pinkColor,
            backgroundColor: themeColor,
            onRefresh: () async {
              isLoadingGetWallpapers.value = true;
              page.value = 1;
              homeController.getPremiumWallpaperList.clear();
              Apis().get_premium_list(Page: page.value.toString(), id: '');
            },
            child: MasonryGridView.count(
              padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w, bottom: 100.0.h),
              physics: AlwaysScrollableScrollPhysics(),
              key: dataKey,
              controller: _scrollController,
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: homeController.getPremiumWallpaperList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => SingleWallpaper(
                        isBottom: true,
                        isPaid: isPaidWallpaper(homeController.getPremiumWallpaperList[index].isPaid ?? ''),
                        wallType: 'premium',
                        wall: List.generate(
                            homeController.getPremiumWallpaperList.length,
                            (i) => Wall(
                                id: homeController.getPremiumWallpaperList[i].id ?? '',
                                title: homeController.getPremiumWallpaperList[i].premiumName ?? '',
                                image: homeController.getPremiumWallpaperList[i].premiumImage ?? '')),
                        index: index));
                  },
                  child: Container(
                    height: isTab(context) ? 300.h : 210.h,
                    decoration: BoxDecoration(color: themeColor, border: Border.all(color: whiteColor, width: 0.5, style: BorderStyle.solid), borderRadius: BorderRadius.circular(5)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) => commonShimmer(),
                            imageUrl: homeController.getPremiumWallpaperList[index].premiumImage ?? '',
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
                                        formatFollowerCount(int.parse(homeController.getPremiumWallpaperList[index].premiumView ?? '')),
                                        fontSize: 12.0.sp,
                                      )
                                    ],
                                  ),
                                ),
                                homeController.getPremiumWallpaperList[index].isPaid == '1'
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
          );
        } else {
          return SizedBox(
            height: commonHeight(context),
            width: commonWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextModel(
                  'No Data Found...',
                  color: whiteColor,
                  fontSize: 20.0,
                  fontFamily: 'R',
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
