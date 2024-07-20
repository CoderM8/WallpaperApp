import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/screens/no_internet.dart';

import '../../api_services/home_services.dart';
import '../../app_extension/appextension.dart';
import '../../controller/home/homecontroller.dart';
import '../../modal/wallmodel.dart';
import '../../res.dart';
import '../bottomscreen/bottomscreen.dart';
import '../singlewallpaper.dart';

class LatestSeeMoreScreen extends StatefulWidget {
  const LatestSeeMoreScreen({super.key});

  @override
  State<LatestSeeMoreScreen> createState() => _LatestSeeMoreScreenState();
}

class _LatestSeeMoreScreenState extends State<LatestSeeMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextModel(
          'Latest',
          color: whiteColor,
          fontSize: 24.0,
        ),
        centerTitle: true,
        leading: BackButton(
          color: whiteColor,
        ),
      ),
      body: Latest(),
    );
  }
}

class Latest extends StatefulWidget {
  const Latest({super.key});

  @override
  State<Latest> createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  RxInt page = 1.obs;
  final dataKey = new GlobalKey();

  late RxBool _isVisible;
  ScrollController _scrollController = ScrollController();

  pagination() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        ((homeController.getWallPaper.value.hdWallpaper?.length ?? 0) % 9 < (int.parse(homeController.getWallPaper.value.hdWallpaper?.first.num ?? ''))) &&
        ((homeController.getWallPaper.value.hdWallpaper?.length ?? 0) < (int.parse(homeController.getWallPaper.value.hdWallpaper?.first.num ?? '')))) {
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
        if (internetController.connectionType.value == 1 || internetController.connectionType.value == 2 || internetController.connectionType.value == 3) {
          if (homeController.getWallPaperList.isNotEmpty) {
            return RefreshIndicator(
              color: pinkColor,
              backgroundColor: themeColor,
              onRefresh: () async {
                page.value = 1;
                homeController.getWallPaperList.clear();
                Apis().getWallpaper(Page: '${page.value}');
              },
              child: MasonryGridView.count(
                key: dataKey,
                controller: _scrollController,
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                itemCount: homeController.getWallPaperList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SingleWallpaper(
                          isBottom: false,
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
                      height: (index % 3 + 4) * 60,
                      decoration: BoxDecoration(color: themeColor, border: Border.all(color: whiteColor, width: 0.5, style: BorderStyle.solid), borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
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
            );
          } else {
            return SizedBox.shrink();
          }
        }
        return NoInternetScreen();
      }),
    );
  }
}
