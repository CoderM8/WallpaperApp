// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';

class ButtonWidget extends GetView {
  const ButtonWidget(
      {Key? key,
      required this.title,
      required this.titleColor,
      this.buttonColor,
      required this.onTap,
      this.width,
      this.height,
      this.borderRadius,
      this.fontSize,
      this.isBorder = false,
      this.isEmpty = false,
      this.isLoad = false,
      this.fontWeight,
      this.icon})
      : super(key: key);
  final String title;
  final Color titleColor;
  final Color? buttonColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final bool? isBorder;
  final bool? isEmpty;
  final bool? isLoad;
  final FontWeight? fontWeight;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: isLoad == true ? null : onTap,
      child: Container(
        height: height ?? 56.h,
        width: isLoad == false ? width ?? 327.w : 56.h,
        decoration: isEmpty == true
            ? BoxDecoration(
                color: isBorder == true
                    ? Colors.transparent
                    : buttonColor ?? greyColor,
                borderRadius: BorderRadius.circular(borderRadius ?? 50.r),
                border: isBorder == true
                    ? Border.all(color: whiteColor, width: 1.w)
                    : null)
            : BoxDecoration(
                color: isBorder == true
                    ? Colors.transparent
                    : buttonColor ?? pinkColor,
                borderRadius: BorderRadius.circular(borderRadius ?? 50.r),
                border: isBorder == true
                    ? Border.all(color: whiteColor, width: 1.w)
                    : null),
        child: isLoad == false
            ? icon == null
                ? Center(
                    child: TextModel(title,
                        color: titleColor,
                        fontFamily: 'M',
                        fontSize: fontSize ?? 16.sp,
                        fontWeight: fontWeight))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      SizedBox(width: 16.w),
                      Center(
                          child: TextModel(title,
                              color: titleColor,
                              fontFamily: 'M',
                              fontSize: 16.sp,
                              fontWeight: fontWeight)),
                    ],
                  )
            : AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: Center(
                  child: SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: CircularProgressIndicator(
                        color: whiteColor, strokeWidth: 3.w),
                  ),
                ),
              ),
      ),
    );
  }
}
