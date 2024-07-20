import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/api_services/home_services.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/home/homecontroller.dart';
import 'package:wallpapers_hd/screens/no_internet.dart';
import '../../../app_extension/appextension.dart';
import '../../../app_widget/customwidget.dart';
import '../../../modal/wallmodel.dart';
import '../../../res.dart';
import '../../bottomscreen/bottomscreen.dart';
import '../../singlewallpaper.dart';

class PopularWallpaperList extends StatefulWidget {
  final String image;
  final String id;
  final String name;

  const PopularWallpaperList({super.key, required this.image, required this.id, required this.name});

  @override
  State<PopularWallpaperList> createState() => _PopularWallpaperListState();
}

class _PopularWallpaperListState extends State<PopularWallpaperList> {
  RxInt page = 1.obs;
  bool _isSliverAppBarExpanded = false;

  ScrollController _scrollController = ScrollController();

  pagination() async {
    if (homeController.getPopularSectionWallpaperList.isNotEmpty &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        ((homeController.getPopularSectionWallpaperList.length) < (int.parse(homeController.getPopularSectionWallpaperList.first.num ?? ''))) &&
        ((homeController.getPopularSectionWallpaperList.length) % 9 < (int.parse(homeController.getPopularSectionWallpaperList.first.num ?? '')))) {
      page.value++;
      Apis().getPopularSectionWallpaperList(Page: page.value.toString(), id: widget.id);
    }
  }

  @override
  void initState() {
    isLoadingGetWallpapers.value = true;
    homeController.getPopularSectionWallpaperList.clear();
    page.value = 1;
    Apis().getPopularSectionWallpaperList(Page: page.value.toString(), id: widget.id);
    _scrollController.addListener(pagination);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (internetController.connectionType.value == 1 || internetController.connectionType.value == 2 || internetController.connectionType.value == 3) {
          return RefreshIndicator(
              color: pinkColor,
              backgroundColor: themeColor,
              onRefresh: () async {
                isLoadingGetWallpapers.value = true;
                homeController.getPopularSectionWallpaperList.clear();
                page.value = 1;
                Apis().getPopularSectionWallpaperList(Page: page.value.toString(), id: widget.id);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    ),
                    pinned: true,
                    leading: BackButton(
                      color: whiteColor,
                    ),
                    snap: false,
                    floating: false,
                    expandedHeight: 300.h,
                    flexibleSpace: _isSliverAppBarExpanded
                        ? null
                        : FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(right: 10.w, bottom: 10.h, left: 10.0.w),
                            expandedTitleScale: 1.5,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: TextModel(
                                    textAlign: TextAlign.start,
                                    widget.name,
                                    fontSize: 18.0,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'SB',
                                  ),
                                ),
                              ],
                            ),
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(widget.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: isTab(context) ? 70 : 70.0.h, horizontal: isTab(context) ? 200.w : 130.w),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    height: 200.h,
                                    // width: isTab(context) ? 30 : 130.w,
                                    // width: 30,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Hero(
                                          tag: widget.image,
                                          child: CachedNetworkImage(
                                            imageUrl: widget.image,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Obx(() {
                    if (isLoadingGetWallpapers.value == true) {
                      return SliverToBoxAdapter(
                          child: SizedBox(
                              height: commonHeight(context) / 2,
                              width: commonWidth(context),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: pinkColor,
                              ))));
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                        child: homeController.getPopularSectionWallpaperList.isEmpty
                            ? SizedBox(
                                height: commonHeight(context) / 2,
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
                              )
                            : GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: homeController.getPopularSectionWallpaperList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 190.h),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => SingleWallpaper(
                                          isBottom: false,
                                          isPaid: isPaidWallpaper(homeController.getPopularSectionWallpaperList[index].isPaid ?? ''),
                                          wallType: 'popular',
                                          wall: List.generate(
                                              homeController.getPopularSectionWallpaperList.length,
                                              (i) => Wall(
                                                  id: homeController.getPopularSectionWallpaperList[i].id ?? '',
                                                  title: homeController.getPopularSectionWallpaperList[i].pWallpaperName ?? '',
                                                  image: homeController.getPopularSectionWallpaperList[i].pWallpaperImage ?? '')),
                                          index: index));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) => commonShimmer(),
                                              fit: BoxFit.cover,
                                              imageUrl: homeController.getPopularSectionWallpaperList[index].pWallpaperImage ?? '',
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
                                                          formatFollowerCount(int.parse(homeController.getPopularSectionWallpaperList[index].popularView ?? '')),
                                                          fontSize: 12.0.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  homeController.getPopularSectionWallpaperList[index].isPaid == '1'
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
                      ),
                    );
                  })
                ],
              ));
        }
        return NoInternetScreen();
      }),
    );
  }
}
