import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';

class AboutApp extends GetView {
  const AboutApp({Key? key, required this.title, required this.text}) : super(key: key);
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel(
          title,
          fontSize: 20.sp,
          fontFamily: 'M',
        ),
        leadingWidth: 60.w,
        leading: BackButtonWidget(backGroundColor: pinkColor, iconColor: whiteColor),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.all(10.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: whiteColor)),
            child: Html(
              data: text,
              style: {
                "h1": Style(color: whiteColor),
                "strong": Style(color: whiteColor, fontSize: FontSize(16.sp), fontFamily: "SB"),
                "body": Style(color: whiteColor, fontSize: FontSize(13.sp), fontFamily: "M"),
              },
            )),
      ),
    );
  }
}
