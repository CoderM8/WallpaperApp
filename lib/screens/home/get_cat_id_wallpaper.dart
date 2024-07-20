import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

class CategoryWallPaper extends StatefulWidget {
  final String title;
  final String id;
  final bool isColorCat;

  const CategoryWallPaper({super.key, required this.title, required this.id, required this.isColorCat});

  @override
  State<CategoryWallPaper> createState() => _CategoryWallPaperState();
}

class _CategoryWallPaperState extends State<CategoryWallPaper> {
  ImageOrientation? selectedItem;
  RxInt page = 1.obs;

  ScrollController _scrollController = ScrollController();

  pagination() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        ((homeController.getColorWallPapersList.length) % 9 < (int.parse(homeController.getColorWallPapersList.first.num ?? ''))) &&
        ((homeController.getColorWallPapersList.length) < (int.parse(homeController.getColorWallPapersList.first.num ?? '')))) {
      page.value++;
      if (widget.isColorCat == true) {
        Apis().get_wallpaper_by_color_id(Page: page.value.toString(), type: selectedItem ?? ImageOrientation.Portrait, colorId: widget.id);
      } else {
        Apis().getCategoryById(
          cid: widget.id,
          Page: page.value.toString(),
          type: selectedItem ?? ImageOrientation.All,
        );
      }
    }
  }

  @override
  void initState() {
    isLoadingGetWallpapers.value = true;
    homeController.getColorWallPapersList.clear();
    if (widget.isColorCat == true) {
      Apis().get_wallpaper_by_color_id(Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All, colorId: widget.id);
    } else {
      Apis().getCategoryById(cid: widget.id, Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All);
    }
    _scrollController.addListener(pagination);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: whiteColor,
        ),
        centerTitle: true,
        title: TextModel(
          widget.title,
          fontSize: 24.0,
          letterSpacing: 1,
          fontFamily: 'SB',
        ),
        actions: [
          PopupMenuButton<ImageOrientation>(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            iconColor: whiteColor,
            initialValue: selectedItem,
            color: themeColor,
            onSelected: (ImageOrientation item) {
              setState(() {
                isLoadingGetWallpapers.value = true;
                homeController.getColorWallPapersList.clear();
                page.value = 1;
                selectedItem = item;
                if (widget.isColorCat == true) {
                  Apis().get_wallpaper_by_color_id(Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All, colorId: widget.id);
                } else {
                  Apis().getCategoryById(cid: widget.id, Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All);
                }
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
                  fontSize: 14.0.sp,
                ),
              ),
              PopupMenuItem<ImageOrientation>(
                value: ImageOrientation.Landscape,
                child: TextModel(
                  orientationStringMap[ImageOrientation.Landscape].toString(),
                  color: whiteColor,
                  fontSize: 14.0.sp,
                ),
              ),
              PopupMenuItem<ImageOrientation>(
                value: ImageOrientation.Square,
                child: TextModel(
                  orientationStringMap[ImageOrientation.Square].toString(),
                  color: whiteColor,
                  fontSize: 14.0.sp,
                ),
              ),
            ],
          )
        ],
      ),
      body: Obx(() {
        if (internetController.connectionType.value == 1 || internetController.connectionType.value == 2 || internetController.connectionType.value == 3) {
          if (isLoadingGetWallpapers.isTrue) {
            return SizedBox(
              height: commonHeight(context),
              width: commonWidth(context),
              child: Center(
                child: CircularProgressIndicator(
                  color: pinkColor,
                ),
              ),
            );
          } else {
            if (homeController.getColorWallPapersList.isNotEmpty) {
              return RefreshIndicator(
                backgroundColor: themeColor,
                color: pinkColor,
                onRefresh: () async {
                  isLoadingGetWallpapers.value = true;
                  page.value = 1;
                  homeController.getColorWallPapersList.clear();
                  if (widget.isColorCat == true) {
                    Apis().get_wallpaper_by_color_id(Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All, colorId: widget.id);
                  } else {
                    Apis().getCategoryById(cid: widget.id, Page: page.value.toString(), type: selectedItem ?? ImageOrientation.All);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: homeController.getColorWallPapersList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => SingleWallpaper(
                              isBottom: false,
                              isPaid: isPaidWallpaper(homeController.getColorWallPapersList[index].isPaid ?? ''),
                              wallType: 'category',
                              wall: List.generate(
                                  homeController.getColorWallPapersList.length,
                                  (i) => Wall(
                                      id: homeController.getColorWallPapersList[i].id ?? '',
                                      title: homeController.getColorWallPapersList[i].wallTags ?? '',
                                      image: homeController.getColorWallPapersList[i].wallpaperImage ?? '')),
                              index: index));
                        },
                        child: Container(
                          height: isTab(context) ? 300.h : 210.h,
                          decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => commonShimmer(),
                                  fit: BoxFit.cover,
                                  imageUrl: homeController.getColorWallPapersList[index].wallpaperImage ?? '',
                                  memCacheHeight: 800,
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
                                              formatFollowerCount(int.parse(homeController.getColorWallPapersList[index].totalViews ?? '')),
                                              fontSize: 12.0.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      homeController.getColorWallPapersList[index].isPaid == '1'
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
          }
        }
        return NoInternetScreen();
      }),
    );
  }
}
