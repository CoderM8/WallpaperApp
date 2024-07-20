// import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/app_widget/cacheImage_widget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/home/homecontroller.dart';
import 'package:wallpapers_hd/res.dart';
import 'package:wallpapers_hd/screens/auth/login.dart';
import 'package:wallpapers_hd/screens/bottomscreen/bottomscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () async {
      await initPlugin();
      Get.offAll(() => userId == null ? LoginScreen() : BottomScreen());
    });
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;

    print("TrackingStatus: $status");
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));

      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    if (status == TrackingStatus.authorized) {
      await AppTrackingTransparency.getAdvertisingIdentifier();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CacheImage(imageUrl: Res.mainicon, imageType: ImageType.asset),
      ),
    );
  }
}
