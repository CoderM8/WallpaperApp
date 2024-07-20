import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wallpapers_hd/admob/admobid.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';

import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/profile/profilecontroller.dart';
import 'package:wallpapers_hd/res.dart';
import 'package:wallpapers_hd/screens/about.dart';
import 'package:wallpapers_hd/screens/databasefav/favourite.dart';
import 'package:wallpapers_hd/screens/subscriptionScreen.dart';

import '../Notification/local_notification_services.dart';
import '../app_widget/cacheImage_widget.dart';

final ProfileController profileController = Get.put(ProfileController());

class ProfileScreen extends GetView {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextModel('Profile', fontSize: 20.sp, fontFamily: 'M'),
        centerTitle: true,
        actions: [
          Platform.isAndroid
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => SubscriptionScreen(
                            isBottom: true,
                          ));
                    },
                    child: SvgPicture.asset(
                      Res.premium,
                      height: 40.h,
                      width: 40.w,
                      colorFilter: ColorFilter.mode(goldenColor, BlendMode.srcIn),
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Obx(() {
                profileController.isUpload.value;
                return Stack(
                  children: [
                    CacheImage(
                        imageUrl: userProfile.isEmpty
                            ? ''
                            : profileController.selectImage == null
                                ? userProfile[0].image
                                : profileController.selectImage!.path,
                        imageType: profileController.selectImage == null ? ImageType.network : ImageType.file,
                        height: 120.w,
                        circle: true,
                        width: 120.w),
                    if (userId != null || type != null || type == 'Normal')
                      Positioned(
                        bottom: 7.h,
                        right: 0,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            profileController.pickedImage();
                          },
                          child: Container(
                            height: 30.w,
                            width: 30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pinkColor,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(Res.edit),
                          ),
                        ),
                      )
                  ],
                );
              }),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (userProfile.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      TextModel(userProfile[0].name, fontSize: 15.sp),
                      SizedBox(height: 8.h),
                      TextModel(userProfile[0].email, fontSize: 15.sp),
                      SizedBox(height: 30.h),
                    ] else ...[
                      SizedBox(height: 20.h),
                      TextModel('Guest', fontSize: 15.sp),
                      SizedBox(height: 30.h),
                    ],
                  ],
                );
              }),
              if (userId != null)
                ListTileWidget(
                  text: 'My wishlist',
                  svgUrl: Res.star,
                  onTap: () {
Get.to(() => Favourite(showBack: true));

                  },
                ),
              ListTileWidget(
                text: 'About Us',
                svgUrl: Res.info,
                onTap: () {
                  Get.to(() => AboutApp(title: 'About us', text: appAbout ?? 'About app'));
                },
              ),
              ListTileWidget(
                text: 'Privacy policy',
                svgUrl: Res.policy,
                onTap: () {
                  Get.to(() => AboutApp(title: 'Privacy policy', text: appPolicy ?? 'Privacy policy'));
                },
              ),
              ListTileWidget(
                text: 'Terms & condition',
                svgUrl: Res.terms,
                onTap: () {
                  Get.to(() => AboutApp(title: 'Terms & condition', text: appTerms ?? 'Terms & condition'));
                },
              ),
              ListTileWidget(
                text: 'Rate us',
                svgUrl: Res.star,
                onTap: () async {
                  if (!await launchUrl(Uri.parse(appRate))) {
                    throw Exception('Could not launch ${Uri.parse(appRate)}');
                  }
                },
              ),
              ListTileWidget(
                text: 'Share',
                svgUrl: Res.share,
                onTap: () {
                  isTab(context)
                      ? Share.share(
                          sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2),
                          'Wallplix 4K Ultra HD Wallpaper ${appShare}',
                        )
                      : Share.share('Wallplix 4K Ultra HD Wallpaper ${appShare}');
                },
              ),
              ListTileWidget(
                text: userId == null ? 'Log In' : 'Log Out',
                svgUrl: Res.logout,
                color: whiteColor,
                onTap: () async {
                  if (userId == null) {
                    await userLogout();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        backgroundColor: themeColor,
                        actionsAlignment: MainAxisAlignment.center,
                        title: TextModel('Logout app'),
                        content: TextModel('Do you want to logout App?', fontSize: 15.sp),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await userLogout();
                            },
                            child: TextModel('Log Out', fontSize: 15.sp, color: themeColor, fontFamily: "B"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              if (userId != null)
                ListTileWidget(
                  text: 'Delete Account',
                  svgUrl: Res.delete,
                  color: whiteColor,
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        backgroundColor: themeColor,
                        actionsAlignment: MainAxisAlignment.center,
                        title: TextModel('Delete Account'),
                        content: TextModel('Do you want to delete Account?', fontSize: 15.sp),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await userLogout();
                            },
                            child: TextModel('Delete', fontSize: 15.sp, color: themeColor, fontFamily: "B"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(height: 101.h),
            ],
          ),
        ),
      ),
    );
  }
}
