import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/api_services/home_services.dart';

import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';

import 'package:wallpapers_hd/controller/search/searchcontroller.dart';

import 'package:wallpapers_hd/screens/singlewallpaper.dart';

import '../app_extension/appextension.dart';
import '../controller/home/homecontroller.dart';
import '../modal/wallmodel.dart';
import '../res.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounceTimer;

  RxString _query = ''.obs;

  RxInt gifPage = 1.obs;
  RxInt wallPage = 1.obs;
  RxInt tabNum = 0.obs;
  Rx<ImageOrientation> selectedItem = ImageOrientation.Portrait.obs;

  ScrollController _gifScrollController = ScrollController();
  ScrollController _wallScrollController = ScrollController();

  gifPagination() async {
    if (_gifScrollController.position.pixels == _gifScrollController.position.maxScrollExtent &&
        ((searchController.searchGifList.length) % 9 < (int.parse(searchController.searchGifList.first.num ?? ''))) &&
        ((searchController.searchGifList.length) < (int.parse(searchController.searchGifList.first.num ?? '')))) {
      gifPage.value++;
      Apis().getUserSearchGif(text: _query.value, Page: gifPage.value.toString());
    }
  }

  wallPagination() async {
    if (_wallScrollController.position.pixels == _wallScrollController.position.maxScrollExtent &&
        ((searchController.searchWallpaperList.length) % 9 < (int.parse(searchController.searchWallpaperList.first.num ?? ''))) &&
        ((searchController.searchWallpaperList.length) < (int.parse(searchController.searchWallpaperList.first.num ?? '')))) {
      wallPage.value++;
      Apis().getUserSearchWallpaper(text: _query.value, Page: wallPage.value.toString(), type: selectedItem.value);
    }
  }

  void _onSearchChanged(String query) {
    _query.value = query;
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    gifPage.value = 1;
    wallPage.value = 1;
    tabNum.value == 0 ? searchController.searchWallpaperList.clear() : searchController.searchGifList.clear();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      tabNum.value == 0 ? Apis().getUserSearchWallpaper(text: query, Page: wallPage.value.toString(), type: selectedItem.value) : Apis().getUserSearchGif(text: query, Page: gifPage.value.toString());
    });
  }

  @override
  void initState() {
    _gifScrollController.addListener(gifPagination);
    _wallScrollController.addListener(wallPagination);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (value) {
                tabNum.value = value;
                _query.value = '';
                setState(() {});
              },
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: whiteColor,
              tabs: [
                Tab(
                  child: TextModel('WALLPAPER', fontSize: 20.sp, fontFamily: 'M'),
                ),
                Tab(
                  child: TextModel('GIF', fontSize: 20.sp, fontFamily: 'M'),
                ),
              ],
            ),
            centerTitle: true,
            title: Obx(() {
              return !searchController.isSearch.value
                  ? TextModel('HD Wallpaper', fontSize: 20.sp, fontFamily: 'M')
                  : TextFieldModel(
                      hint: 'Search here',
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      hideBorder: true,
                      focusNode: searchController.focusNode,
                      controller: searchController.textEditingController,
                      onChanged: _onSearchChanged,
                    );
            }),
            actions: [
              Obx(() {
                return IconButton(
                  splashColor: Colors.transparent,
                  splashRadius: 10.r,
                  onPressed: () {
                    searchController.isSearch.value = !searchController.isSearch.value;
                    searchController.textEditingController.clear();
                    if (searchController.isSearch.value) {
                      searchController.focusNode.requestFocus();
                    } else {
                      searchController.focusNode.unfocus();
                    }
                  },
                  icon: Icon(searchController.isSearch.value ? Icons.close : Icons.search, color: whiteColor),
                );
              }),
              Obx(() {
                return tabNum.value == 0
                    ? PopupMenuButton<ImageOrientation>(
                        color: themeColor,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        iconColor: whiteColor,
                        initialValue: selectedItem.value,
                        onSelected: (ImageOrientation item) {
                          setState(() {
                            selectedItem.value = item;
                            searchController.searchWallpaperList.clear();
                            wallPage.value = 1;
                            Apis().getUserSearchWallpaper(text: _query.value, Page: wallPage.value.toString(), type: item);
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
          ),
          body: TabBarView(children: [WallpaperTab(), gifTab()])),
    );
  }

  Widget gifTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
      child: Obx(() {
        return RefreshIndicator(
          color: pinkColor,
          backgroundColor: themeColor,
          onRefresh: () async {
            searchController.searchGifList.clear();
            gifPage.value = 1;
            Apis().getUserSearchGif(text: '', Page: gifPage.value.toString());
          },
          child: MasonryGridView.count(
            controller: _gifScrollController,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: searchController.searchGifList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SingleWallpaper(
                      isBottom: true,
                      isPaid: isPaidWallpaper('0'),
                      wallType: 'search_gif',
                      gif: true,
                      wall: List.generate(searchController.searchGifList.length,
                          (i) => Wall(id: searchController.searchGifList[i].id ?? '', title: searchController.searchGifList[i].gifTags ?? '', image: searchController.searchGifList[i].gifImage ?? '')),
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
                          imageUrl: searchController.searchGifList[index].gifImage ?? '',
                          memCacheHeight: 700,
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
                                  formatFollowerCount(int.parse(searchController.searchGifList[index].totalViews ?? '')),
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

  Widget WallpaperTab() {
    return RefreshIndicator(
      color: pinkColor,
      backgroundColor: themeColor,
      onRefresh: () async {
        searchController.searchWallpaperList.clear();
        wallPage.value = 1;
        Apis().getUserSearchWallpaper(text: '', Page: wallPage.value.toString(), type: selectedItem.value);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
        child: Obx(() {
          return MasonryGridView.count(
            controller: _wallScrollController,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: searchController.searchWallpaperList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SingleWallpaper(
                      isBottom: true,
                      isPaid: isPaidWallpaper(searchController.searchWallpaperList[index].isPaid ?? ''),
                      wallType: 'search_wall',
                      wall: List.generate(
                          searchController.searchWallpaperList.length,
                          (i) => Wall(
                              id: searchController.searchWallpaperList[i].id ?? '',
                              title: searchController.searchWallpaperList[i].categoryName ?? '',
                              image: searchController.searchWallpaperList[i].wallpaperImage ?? '')),
                      index: index));
                },
                child: Container(
                  height: isTab(context) ? 300.h : 210.h,
                  decoration: BoxDecoration(color: themeColor, border: Border.all(color: whiteColor, width: 0.5, style: BorderStyle.solid), borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => commonShimmer(),
                          fit: BoxFit.cover,
                          imageUrl: searchController.searchWallpaperList[index].wallpaperImage ?? '',
                          memCacheHeight: 700,
                        ),
                      ),
                      // Positioned(
                      //     right: commonWidth(context) * 0.010,
                      //     top: commonHeight(context) * 0.010,
                      //     child: Container(
                      //       height: commonHeight(context) * 0.030,
                      //       width: isTab(context) ? commonWidth(context) * 0.12 : commonWidth(context) * 0.15,
                      //       decoration: BoxDecoration(color: themeColor.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                      //       child: Row(
                      //         children: [
                      //           SizedBox(
                      //             width: 5.w,
                      //           ),
                      //           Icon(
                      //             Icons.remove_red_eye_sharp,
                      //             size: 20.0.sp,
                      //           ),
                      //           SizedBox(
                      //             width: 5.w,
                      //           ),
                      //           TextModel(
                      //             formatFollowerCount(int.parse(searchController.searchWallpaperList[index].totalViews ?? '')),
                      //             fontSize: 12.0.sp,
                      //           ),
                      //
                      //         ],
                      //       ),
                      //     ))
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
                                      formatFollowerCount(int.parse(searchController.searchWallpaperList[index].totalViews ?? '')),
                                      fontSize: 12.0.sp,
                                    )
                                  ],
                                ),
                              ),
                              searchController.searchWallpaperList[index].isPaid == '1'
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
        }),
      ),
    );
  }
}
