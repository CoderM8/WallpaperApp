import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/app_widget/cacheImage_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';

import '../admob/admobid.dart';
import '../app_widget/button_widget.dart';
import '../subscription/subscription.dart';
import 'about.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool isBottom;

  const SubscriptionScreen({super.key, required this.isBottom});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  RxInt selectedIndex = 100.obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  List<String> subscriptionAccessList = ['100% ADS Free', 'Unlimited Download Wallpaper', '10+ Unique Wallpaper Categories', 'New Premium Wallpapers Weekly'];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        Future.delayed(Duration.zero, () {
          if (widget.isBottom == true) {
            Get.back();
            Get.back();
          } else {
            Get.back();
          }
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: 400.h,
              width: commonWidth(context),
              child: CacheImage(
                imageUrl: 'assets/images/subscription_wall.png',
                imageType: ImageType.asset,
              ),
            ),
            Obx(() {
              return AppBar(
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  ButtonWidget(
                    height: 40.h,
                    width: 100.w,
                    title: 'Restore',
                    isLoad: isLoading.value,
                    titleColor: whiteColor,
                    onTap: () async {
                      isLoading.value = true;
                      Config.restoreSubscription().whenComplete(() => isLoading.value = false);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
                leadingWidth: 60.w,
                leading: BackButtonWidget(
                  backGroundColor: pinkColor,
                  iconColor: whiteColor,
                  onTap: () {
                    if (widget.isBottom == true) {
                      Get.back();
                      Get.back();
                    } else {
                      Get.back();
                    }
                  },
                ),
              );
            }),
            Positioned(
              top: 200.h,
              left: 0.00001,
              right: 0.00001,
              child: Container(
                height: 200.h,
                width: commonWidth(context),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: List.generate(
                          5,
                          (index) => themeColor.withOpacity(index / 5),
                        ))),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 200.h,
                ),
                TextModel(
                  'UNLIMITED',
                  fontSize: 30,
                  color: whiteColor,
                  fontFamily: "SB",
                ),
                TextModel(
                  'ACCESS',
                  fontSize: 24,
                  color: whiteColor,
                  fontFamily: "SB",
                ),
                ListView.builder(
                  padding: EdgeInsets.only(left: 20.w, bottom: 0.0),
                  shrinkWrap: true,
                  itemCount: subscriptionAccessList.length,
                  itemBuilder: (context, index) => Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            size: 18.sp,
                            color: goldenColor,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          TextModel(
                            subscriptionAccessList[index],
                            fontSize: 18.sp,
                            fontFamily: 'SB',
                            color: whiteColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Obx(() {
                  if (subscriptionPlanList.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subscriptionPlanList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 4.h, bottom: 4.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subscriptionPlanList[index].subscriptionPeriod != null && subscriptionPlanList[index].subscriptionPeriod?.contains('P1Y') == true
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 18.0.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          color: pinkColor,
                                        ),
                                        height: 30.h,
                                        width: 100.w,
                                        child: TextModel(
                                          'Popular',
                                          fontSize: 16.sp,
                                          fontFamily: 'SB',
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              GestureDetector(
                                onTap: () {
                                  selectedIndex.value = index;
                                  subscriptionPlan.value = subscriptionPlanList[index];
                                },
                                child: Obx(() {
                                  return Container(
                                    padding: EdgeInsets.all(10.h),
                                    height: 67.h,
                                    width: commonWidth(context),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: selectedIndex.value == index ? pinkColor : whiteColor, width: 2),
                                      borderRadius: BorderRadius.circular(15.sp),
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextModel(
                                              subscriptionPlanList[index].title,
                                              fontSize: 16.sp,
                                              fontFamily: 'SB',
                                              color: whiteColor,
                                            ),
                                            subscriptionPlanList[index].title.contains('Life Time')
                                                ? TextModel(
                                                    '👑 One-Time payment',
                                                    fontSize: 12.sp,
                                                    fontFamily: 'SB',
                                                    color: whiteColor,
                                                  )
                                                : TextModel(
                                                    '🔁 Auto-Renewal',
                                                    fontSize: 12.sp,
                                                    fontFamily: 'SB',
                                                    color: whiteColor,
                                                  )
                                          ],
                                        ),
                                        Spacer(),
                                        TextModel(
                                          subscriptionPlanList[index].priceString + ' / ' + subscriptionPlanList[index].title,
                                          fontSize: 14.sp,
                                          fontFamily: 'SB',
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: TextModel(
                              'No Data Found...',
                              color: whiteColor,
                              fontSize: 20.0,
                              fontFamily: 'R',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                SizedBox(
                  height: 15.0.h,
                ),
                subscriptionPlanList.isNotEmpty
                    ? Obx(() {
                        return ButtonWidget(
                          height: 60.h,
                          width: 200.w,
                          isLoad: isLoading1.value,
                          title: 'Buy Now',
                          titleColor: whiteColor,
                          onTap: () async {
                            isLoading1.value = true;
                            Config.buySubscription(context, item: subscriptionPlan.value).whenComplete(() => isLoading1.value = false);
                          },
                        );
                      })
                    : SizedBox.shrink(),
                subscriptionPlanList.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.to(() => AboutApp(title: 'Privacy policy', text: appPolicy ?? 'Privacy policy'));
                              },
                              child: TextModel(fontSize: 14.sp, 'Privacy Policy')),
                          TextButton(
                              onPressed: () {
                                Get.to(() => AboutApp(title: 'Terms & condition', text: appTerms ?? 'Terms & condition'));
                              },
                              child: TextModel(
                                fontSize: 14.sp,
                                'Terms & condition',
                              )),
                        ],
                      )
                    : SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
