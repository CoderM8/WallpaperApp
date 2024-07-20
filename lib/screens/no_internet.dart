import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/app_widget/button_widget.dart';
import 'package:wallpapers_hd/app_widget/cacheImage_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(radius: 0.9, center: Alignment.centerLeft, colors: [pinkColor.withOpacity(0.2), themeColor]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheImage(
              imageUrl: 'assets/images/oops.png',
              imageType: ImageType.asset,
              height: 350.h,
              width: 350.w,
            ),
            // SvgPicture.asset('assets/images/oops.svg'),
            SizedBox(
              height: 25.0.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0.w),
              child: TextModel(
                'No internet connection!',
                fontSize: 28.sp,
                fontFamily: 'SB',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0.w, right: 24.w),
              child: TextModel(
                'Something went wrong. Try refreshing the page or checking your internet connection. We\'ll see you in a moment!',
                fontSize: 14.sp,
                fontFamily: 'M',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: ButtonWidget(
                  title: 'Go To Setting',
                  titleColor: whiteColor,
                  onTap: () {
                    AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
