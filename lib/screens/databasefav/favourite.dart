// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/cacheImage_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/home/homecontroller.dart';
import 'package:wallpapers_hd/modal/wallmodel.dart';
import 'package:wallpapers_hd/screens/databasefav/db.dart';
import 'package:wallpapers_hd/screens/singlewallpaper.dart';

import '../../app_extension/appextension.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key, this.showBack}) : super(key: key);
  final bool? showBack;

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leadingWidth: 60.w,
          leading: widget.showBack == true ? BackButtonWidget(backGroundColor: pinkColor, iconColor: whiteColor) : null,
          title: TextModel('HD Wallpaper', fontSize: 20.sp, fontFamily: 'M'),
          bottom: TabBar(
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
        ),
        body: TabBarView(
          children: [
            ///wallpaper
            Obx(() {
              homeController.isFavorite.value;
              return FutureBuilder<List<FavouriteWallpaper>>(
                future: DBHelper().getFavouriteWallpapers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final List<FavouriteWallpaper> favList = snapshot.data!;
                    if (favList.isNotEmpty) {
                      return GridView.builder(
                        itemCount: favList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (200 / 250),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final task = favList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => SingleWallpaper(
                                    isBottom: true,
                                    isPaid: isPaidWallpaper(favList[index].isPaid),
                                    wallType: favList[index].type,
                                    index: index,
                                    wall: List.generate(
                                      favList.length,
                                      (i) => Wall(id: favList[i].id.toString(), title: favList[i].name, image: favList[i].imageurl),
                                    ),
                                  ));
                            },
                            child: Stack(
                              children: [
                                CacheImage(
                                    imageUrl: task.imageurl, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                                Positioned(
                                  top: 10.h,
                                  right: 10.w,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      DBHelper().deleteWallpapers(task.id);
                                      homeController.isFavorite.value = !homeController.isFavorite.value;
                                    },
                                    child: Container(
                                      height: 50.w,
                                      width: 50.w,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.r),
                                      decoration: BoxDecoration(
                                        color: themeColor.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.favorite),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: TextModel('No favorite Wallpaper', fontSize: 18.sp, fontFamily: 'M'),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            }),

            ///gif
            Obx(() {
              homeController.isFavorite.value;
              return FutureBuilder<List<FavouriteGifs>>(
                future: DBHelper().getFavouriteGifs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final List<FavouriteGifs> gifList = snapshot.data!;
                    if (gifList.isNotEmpty) {
                      return GridView.builder(
                        itemCount: gifList.length,
                        padding: EdgeInsets.all(10.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (200 / 250),
                          crossAxisCount: 2,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 3.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final task = gifList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => SingleWallpaper(
                                    isBottom: true,
                                    isPaid: isPaidWallpaper('0'),
                                    wallType: 'fav_gif',
                                    index: index,
                                    wall: List.generate(
                                      gifList.length,
                                      (i) => Wall(id: gifList[i].id.toString(), title: gifList[i].name, image: gifList[i].imageurl),
                                    ),
                                    gif: true,
                                  ));
                            },
                            child: Stack(
                              children: [
                                CacheImage(
                                    imageUrl: task.imageurl, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                                Positioned(
                                  top: 10.h,
                                  right: 10.w,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      DBHelper().deleteGifs(task.id);
                                      homeController.isFavorite.value = !homeController.isFavorite.value;
                                    },
                                    child: Container(
                                      height: 50.w,
                                      width: 50.w,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.r),
                                      decoration: BoxDecoration(
                                        color: themeColor.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.favorite),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: TextModel('No favorite Gif', fontSize: 18.sp, fontFamily: 'M'),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
