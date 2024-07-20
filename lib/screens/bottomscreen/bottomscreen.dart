import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/button_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/bottom/bottomcontroller.dart';
import 'package:wallpapers_hd/screens/databasefav/favourite.dart';
import 'package:wallpapers_hd/screens/gif_screen.dart';
import 'package:wallpapers_hd/screens/home/homescreen.dart';
import 'package:wallpapers_hd/screens/no_internet.dart';
import 'package:wallpapers_hd/screens/profile.dart';
import 'package:wallpapers_hd/screens/search.dart';

import '../../controller/home/homecontroller.dart';

class BottomScreen extends StatefulWidget {
  BottomScreen({Key? key}) : super(key: key);

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}
final ConnectionManagerController internetController = Get.find<ConnectionManagerController>();
class _BottomScreenState extends State<BottomScreen> {
  final BottomController bottomController = Get.put(BottomController());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: PopScope(
          canPop: false,
          onPopInvoked: (value) async {
            await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                backgroundColor: themeColor,
                actionsAlignment: MainAxisAlignment.spaceBetween,
                title: TextModel('Exit App'),
                content: TextModel('Do you want to exit App?', fontSize: 15.sp),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonWidget(
                        width: 110.w,
                        onTap: () {
                          Get.back(canPop: false);
                        },
                        title: 'NO',
                        titleColor: whiteColor,
                      ),
                      ButtonWidget(
                        width: 110.w,
                        onTap: () {
                          exit(0);
                        },
                        title: 'YES',
                        titleColor: whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          child: Obx(() {
            return internetController.connectionType.value == 1 ||
                    internetController.connectionType.value == 2 ||
                    internetController.connectionType.value == 3
                ? Scaffold(
                    backgroundColor: themeColor.withOpacity(0.7),
                    extendBody: true,
                    body: Obx(() {
                      return IndexedStack(
                        children: [HomeScreen(), Favourite(), SearchScreen(), ProfileScreen(), GifScreen()],
                        index: bottomController.select.value,
                      );
                    }),
                    floatingActionButton: Visibility(
                      visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
                      child: Obx(() {
                        return FloatingActionButton(
                          hoverColor: Colors.green,
                          shape: CircleBorder(),
                          heroTag: "btn1",
                          backgroundColor: pinkColor,
                          foregroundColor: bottomController.select.value == 4 ? Colors.blue : whiteColor,
                          child: SizedBox(
                              height: 85,
                              width: 85,
                              child: bottomController.select.value == 4
                                  ? Image.asset(
                                      'assets/Lottie/gif.gif',
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.gif,
                                      size: 42,
                                    )),
                          onPressed: () {
                            bottomController.select.value = 4;
                          },
                        );
                      }),
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: Obx(() {
                      return AnimatedBottomNavigationBar(
                        leftCornerRadius: 15,
                        rightCornerRadius: 15,
                        icons: iconList,
                        iconSize: 30,
                        activeColor: pinkColor,
                        activeIndex: bottomController.select.value,
                        gapLocation: GapLocation.center,
                        backgroundColor: themeColor.withOpacity(0.7),
                        elevation: 10,
                        notchSmoothness: NotchSmoothness.smoothEdge,
                        onTap: (index) => setState(() => bottomController.select.value = index),
                      );
                    }),
                  )
                : NoInternetScreen();
          })),
    );
  }

  final iconList = <IconData>[
    Icons.home,
    Icons.favorite,
    Icons.search,
    Icons.supervised_user_circle_rounded,
  ];
}
