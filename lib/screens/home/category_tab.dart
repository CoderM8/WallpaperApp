import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../api_services/home_services.dart';

import '../../app_extension/appextension.dart';
import '../../app_widget/customwidget.dart';
import '../../constant.dart';
import '../../controller/home/homecontroller.dart';
import 'get_cat_id_wallpaper.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: themeColor,
        color: pinkColor,
        onRefresh: () async {
          homeController.wallpaperColors.clear();
          homeController.getCatGoryList.clear();
          Apis().getHomeApi(Page: '1', type: ImageOrientation.Portrait);
          Apis().getCategory();
        },
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: homeController.wallpaperColors.isNotEmpty && homeController.getCatGoryList.isNotEmpty
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      homeController.wallpaperColors.isNotEmpty ? ColorWallpaper() : SizedBox(),
                      homeController.getCatGoryList.isNotEmpty ? CatTab() : SizedBox(),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: pinkColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget CatTab() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextModel(
            'Categories',
            fontSize: 20.0,
            fontFamily: 'SB',
          ),
          SizedBox(
            height: 10.0,
          ),
          Obx(() {
            if (homeController.getCatGoryList.isNotEmpty) {
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: homeController.getCatGoryList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: commonHeight(context) * 0.140.h, crossAxisCount: 2, mainAxisSpacing: 7.0.h, crossAxisSpacing: 7.0.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CategoryWallPaper(isColorCat: false, title: homeController.getCatGoryList[index].categoryName ?? '', id: homeController.getCatGoryList[index].cid ?? ''));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          StreamBuilder(
                              stream: getDominantColorStreamFromCachedNetworkImage(CachedNetworkImageProvider(maxHeight: 100, maxWidth: 100, homeController.getCatGoryList[index].categoryImage ?? '')),
                              builder: (context, s) {
                                return Container(
                                  height: isTab(context) ? 400.h : commonHeight(context) * 0.150,
                                  width: commonWidth(context) / 2.w,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    border: Border.all(color: s.data?.lightVibrantColor?.color ?? greyColor, style: BorderStyle.solid, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => commonShimmer(),
                                      imageUrl: homeController.getCatGoryList[index].categoryImage ?? '',
                                      fit: BoxFit.cover,
                                      memCacheHeight: 700,
                                      memCacheWidth: 700,
                                    ),
                                  ),
                                );
                              }),
                          Positioned(
                            bottom: commonHeight(context) * 0.008,
                            child: TextModel(
                              homeController.getCatGoryList[index].categoryName ?? '',
                              fontSize: 14.0,
                              fontFamily: 'R',
                            ),
                          ),
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

  Widget ColorWallpaper() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          TextModel(
            'Colors',
            fontSize: 20.0,
            fontFamily: 'SB',
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Obx(() {
            if (homeController.wallpaperColors.isNotEmpty) {
              return SizedBox(
                height: 120.0.h,
                width: commonWidth(context),
                child: ListView.builder(
                  itemCount: homeController.wallpaperColors.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryWallPaper(isColorCat: true, title: homeController.wallpaperColors[index].colorName ?? '', id: homeController.wallpaperColors[index].colorId ?? ''));
                      },
                      child: Padding(
                        padding: isTab(context) ? EdgeInsets.zero : EdgeInsets.all(5.0),
                        child: StreamBuilder(
                            stream: getDominantColorStreamFromCachedNetworkImage(CachedNetworkImageProvider(
                                cacheKey: homeController.wallpaperColors[index].colorCode ?? '', maxHeight: 300, maxWidth: 300, homeController.wallpaperColors[index].colorCode ?? '')),
                            builder: (context, s) {
                              return Container(
                                  height: commonHeight(context) * 0.250,
                                  width: commonWidth(context) * (isTab(context) ? 0.210 : 0.250),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: s.data?.lightVibrantColor?.color ?? whiteColor, width: 2, style: BorderStyle.solid),
                                      color: themeColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              cacheKey: homeController.wallpaperColors[index].colorCode ?? '',
                                              errorListener: (p0) => commonShimmer,
                                              maxHeight: 300,
                                              maxWidth: 300,
                                              homeController.wallpaperColors[index].colorCode ?? ''))),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 14.0.h),
                                    child: TextModel(
                                      homeController.wallpaperColors[index].colorName ?? '',
                                      fontSize: 14.0,
                                      fontFamily: 'R',
                                    ),
                                  ));
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
          SizedBox(
            height: 5.0.h,
          ),
        ],
      ),
    );
  }
}
