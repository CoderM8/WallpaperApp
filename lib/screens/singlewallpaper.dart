import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wallpapers_hd/api_services/home_services.dart';

import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/home/homecontroller.dart';
import 'package:wallpapers_hd/modal/wallmodel.dart';
import 'package:wallpapers_hd/screens/auth/login.dart';
import 'package:wallpapers_hd/screens/no_internet.dart';
import 'package:wallpapers_hd/screens/subscriptionScreen.dart';
import '../admob/admobid.dart';
import '../admob/ads_manager.dart';
import '../controller/Gif/gif_controller.dart';
import '../subscription/subscription.dart';
import 'bottomscreen/bottomscreen.dart';

class SingleWallpaper extends StatefulWidget {
  SingleWallpaper({required this.wall, required this.index, this.gif = false, required this.wallType, required this.isPaid, required this.isBottom});

  final bool isBottom;
  final bool isPaid;
  final bool? gif;
  final String wallType;
  final int index;
  final List<Wall> wall;

  @override
  State<SingleWallpaper> createState() => _SingleWallpaperState();
}

class _SingleWallpaperState extends State<SingleWallpaper> {
  RxBool isLoad = false.obs;

  @override
  void initState() {
    // showInterstitialAdOnClickEvent();
    if (widget.isPaid == true && isSubscribe.value == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showInterstitialAdOnClickEvent();
        Get.to(() => SubscriptionScreen(isBottom: widget.isBottom));
      });
    } else {
      isSubscribe.value == false || Platform.isAndroid ? showInterstitialAdOnClickEvent() : null;

      homeController.getLikeOrNotWall(image: widget.wall[widget.index].image, id: widget.wall[widget.index].id);
      if (widget.gif == true) {
        Apis().getSingleGif(widget.wall[widget.index].id);
      } else {
        switch (widget.wallType) {
          case 'popular':
            Apis().get_popular_wallpaper_list(id: widget.wall[widget.index].id, Page: '1');
            break;
          case 'premium':
            Apis().get_premium_list(Page: '1', id: widget.wall[widget.index].id);
          default:
            homeController.getSingleWallpaper.value.hdWallpaper?.clear();
            Apis().getSingleWallPaper(widget.wall[widget.index].id);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bannerAds(),
      body: Obx(() {
        if (internetController.connectionType.value == 1 || internetController.connectionType.value == 2 || internetController.connectionType.value == 3) {
          if (widget.gif == true) {
            if (gifController.getSingleGif.value.hdWallpaper != null && gifController.getSingleGif.value.hdWallpaper!.isNotEmpty) {
              return getSingleWallpaper(
                  isPaid: '0',
                  type: widget.wallType,
                  image: gifController.getSingleGif.value.hdWallpaper?[0].gifImage ?? '',
                  id: gifController.getSingleGif.value.hdWallpaper?[0].id ?? '',
                  isGif: true,
                  title: gifController.getSingleGif.value.hdWallpaper?[0].gifTags ?? '');
            } else {
              return SizedBox.shrink();
            }
          } else {
            switch (widget.wallType) {
              case 'popular':
                if (homeController.getPopularSingleWallpaper.value.hdWallpaper != null && homeController.getPopularSingleWallpaper.value.hdWallpaper!.isNotEmpty) {
                  return getSingleWallpaper(
                      isPaid: homeController.getPopularSingleWallpaper.value.hdWallpaper?[0].isPaid ?? '',
                      type: widget.wallType,
                      image: homeController.getPopularSingleWallpaper.value.hdWallpaper?[0].pWallpaperImage ?? '',
                      id: homeController.getPopularSingleWallpaper.value.hdWallpaper?[0].id ?? '',
                      isGif: false,
                      title: homeController.getPopularSingleWallpaper.value.hdWallpaper?[0].pWallpaperName ?? '');
                } else {
                  return SizedBox.shrink();
                }
              case 'premium':
                if (homeController.getPremiumWallpaper.value.hdWallpaper!.isNotEmpty) {
                  return getSingleWallpaper(
                      isPaid: homeController.getPremiumWallpaper.value.hdWallpaper?[0].isPaid ?? '',
                      type: widget.wallType,
                      image: homeController.getPremiumWallpaper.value.hdWallpaper?[0].premiumImage ?? '',
                      id: homeController.getPremiumWallpaper.value.hdWallpaper?[0].id ?? '',
                      isGif: false,
                      title: homeController.getPremiumWallpaper.value.hdWallpaper?[0].premiumName ?? '');
                } else {
                  return SizedBox.shrink();
                }

              default:
                if (homeController.getSingleWallpaper.value.hdWallpaper != null && homeController.getSingleWallpaper.value.hdWallpaper!.isNotEmpty) {
                  return getSingleWallpaper(
                      isPaid: homeController.getSingleWallpaper.value.hdWallpaper?[0].isPaid ?? '',
                      type: widget.wallType,
                      image: homeController.getSingleWallpaper.value.hdWallpaper?[0].wallpaperImage ?? '',
                      id: homeController.getSingleWallpaper.value.hdWallpaper?[0].id ?? '',
                      isGif: false,
                      title: homeController.getSingleWallpaper.value.hdWallpaper?[0].categoryName ?? '');
                } else {
                  return SizedBox.shrink();
                }
            }
          }
        } else {
          return NoInternetScreen();
        }
      }),
    );
  }

  Widget getSingleWallpaper({
    required String image,
    required String id,
    required bool isGif,
    required String title,
    required String type,
    required String isPaid,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: pinkColor,
            ),
          ),
          imageUrl: image,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 40.h,
            right: 0.0001,
            left: 0.00001,
            child: Row(
              children: [
                BackButtonWidget(),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      RxDouble rate = 3.0.obs;
                      showModalBottomSheet(
                        useSafeArea: true,
                        constraints: BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        backgroundColor: themeColor,
                        shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                        ),
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              Container(
                                width: commonWidth(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextModel('Rating', fontFamily: "SM", letterSpacing: 1, color: whiteColor, fontSize: 24.sp),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    TextModel(
                                      'HOW WAS EVERYTHING?',
                                      fontFamily: "M",
                                      color: whiteColor,
                                      fontSize: 18.sp,
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextModel(
                                        'Your review help us improve the overall experience...',
                                        fontFamily: "M",
                                        color: whiteColor,
                                        fontSize: 14.sp,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0.h,
                                    ),
                                    StreamBuilder<double>(
                                        stream: rate.stream,
                                        builder: (context, snapshot) {
                                          return RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            wrapAlignment: WrapAlignment.center,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            updateOnDrag: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star_outlined,
                                              color: pinkColor,
                                              size: 60.sp,
                                            ),
                                            onRatingUpdate: (rating) {
                                              rate.value = rating;
                                            },
                                          );
                                        }),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(pinkColor)),
                                      onPressed: () {
                                        Apis().rate(isGif: isGif, id: id, rate: rate.value.toString());
                                        Navigator.pop(context);
                                      },
                                      child: TextModel('Submit', fontFamily: "SM", letterSpacing: 1, color: whiteColor, fontSize: 24.sp),
                                    ),
                                    Platform.isIOS
                                        ? SizedBox(
                                            height: 20.0,
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: themeColor.withOpacity(0.8)),
                      child: Icon(Icons.star_outlined, color: CupertinoColors.systemYellow, size: 30.sp),
                    )),
                SizedBox(width: 10.w),
              ],
            )),
        Positioned(
          bottom: 40.h,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    final box = context.findRenderObject() as RenderBox?;
                    if (userId != null) {
                      isTab(context)
                          ? Share.share(
                              sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2),
                              'Hd WallPaper \n$title \n$image',
                            )
                          : Share.share(
                              'Hd WallPaper \n$title \n$image',
                            );
                    } else {
                      showToast(message: 'Login first');
                      Get.to(() => LoginScreen());
                    }
                  },
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.share, size: 30.w),
                  ),
                ),
                Obx(() {
                  homeController.isDownload.value;
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: !homeController.isDownload.value
                        ? () async {
                            if (userId != null) {
                              if (await storage.read('isRegister') != null && await storage.read('isRegister') == true) {
                                storage.write('isRegister', false);
                                if (!await launchUrl(Uri.parse('https://youtube.com/shorts/itVullg5kR8'))) {
                                  throw Exception('Could not launch ${Uri.parse('https://youtube.com/shorts/itVullg5kR8')}');
                                }
                              } else {
                                await homeController.addToDownload(context, image: image);
                                Apis().download(id: id, isGif: isGif);
                              }
                            } else {
                              showToast(message: 'Login first');
                              Get.to(() => LoginScreen());
                            }
                          }
                        : null,
                    child: Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: homeController.isDownload.value
                          ? SizedBox(
                              height: 20.w,
                              width: 20.w,
                              child: CircularProgressIndicator(color: whiteColor),
                            )
                          : Icon(Icons.cloud_download, size: 30.w),
                    ),
                  );
                }),
                if (Platform.isAndroid && widget.gif == false)
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (userId != null) {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.r),
                              topLeft: Radius.circular(10.r),
                            ),
                          ),
                          builder: (context) {
                            return Obx(() {
                              homeController.isLoading.value;
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 10.h),
                                      TextModel('Set Wallpaper', fontSize: 20.sp, fontFamily: 'M'),
                                      SizedBox(height: 10.h),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          homeController.addWallpaper(image: image, type: LocationType.BOTH_SCREEN);
                                        },
                                        title: TextModel('BOTH SCREEN', fontSize: 18.sp),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          homeController.addWallpaper(image: image, type: LocationType.LOCK_SCREEN);
                                        },
                                        title: TextModel('LOCK SCREEN', fontSize: 18.sp),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          homeController.addWallpaper(image: image, type: LocationType.HOME_SCREEN);
                                        },
                                        title: TextModel('HOME SCREEN', fontSize: 18.sp),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          homeController.removeWallpaper();
                                        },
                                        title: TextModel('Remove wallpaper', fontSize: 18.sp, color: pinkColor),
                                      ),
                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                  if (homeController.isLoading.value) CircularProgressIndicator(color: whiteColor)
                                ],
                              );
                            });
                          },
                        );
                      } else {
                        Get.to(() => LoginScreen());
                        showToast(message: 'Login first');
                      }
                    },
                    child: Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.wallpaper, size: 30.w),
                    ),
                  ),
                Obx(() {
                  homeController.isFavorite.value;
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (userId != null) {
                        await homeController.addToFavorite(context, image: image, title: title, id: id, type: type, isPaid: isPaid);
                      } else {
                        showToast(message: 'Login first');
                        Get.to(() => LoginScreen());
                      }
                    },
                    child: Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(homeController.isFavorite.value ? Icons.favorite : Icons.favorite_border, size: 30.w),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
