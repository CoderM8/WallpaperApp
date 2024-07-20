// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/res.dart';

import '../app_extension/appextension.dart';

class TextFieldModel extends GetView {
  const TextFieldModel(
      {Key? key,
      required this.hint,
      this.label,
      required this.controller,
      required this.textInputType,
      this.obscureText,
      this.focusNode,
      this.validation,
      this.onChanged,
      this.onTap,
      this.onFieldSubmitted,
      this.maxLan,
      this.suffixIcon,
      this.prefixIcon,
      this.minLine,
      this.textInputAction,
      this.maxLine,
      this.expands,
      this.enabled,
      this.hideBorder = false,
      this.readOnly = false,
      this.color,
      this.contentPaddingH,
      this.fillColor})
      : super(key: key);

  @override
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? expands;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final String hint;
  final String? label;
  final String? Function(String?)? validation;
  final bool? obscureText;
  final int? maxLan;
  final int? maxLine;
  final int? minLine;
  final bool? enabled;
  final bool? hideBorder;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? color;
  final Color? fillColor;
  final double? contentPaddingH;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextModel(label!, fontSize: 16.sp, fontFamily: "M", color: whiteColor),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          onChanged: onChanged,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          maxLines: maxLine,
          minLines: minLine,
          maxLength: maxLan,
          expands: expands ?? false,
          validator: validation,
          focusNode: focusNode,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          style: TextStyle(fontSize: 16.sp, color: color ?? whiteColor, fontFamily: 'M'),
          controller: controller,
          obscureText: obscureText ?? false,
          autofocus: false,
          readOnly: readOnly ?? false,
          cursorColor: whiteColor,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingH != null ? contentPaddingH! : 0),
              counterStyle: TextStyle(color: color ?? whiteColor),
              fillColor: fillColor ?? themeColor,
              filled: true,
              focusedBorder: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: whiteColor) : BorderSide.none),
              disabledBorder: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: whiteColor) : BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: whiteColor) : BorderSide.none),
              border: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: whiteColor) : BorderSide.none),
              errorBorder: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: const Color(0xffDC3545)) : BorderSide.none),
              focusedErrorBorder: UnderlineInputBorder(borderSide: hideBorder == false ? BorderSide(width: 1.w, color: const Color(0xffDC3545)) : BorderSide.none),
              hintText: hint,
              hintStyle: TextStyle(fontSize: 16.sp, color: whiteColor, fontFamily: 'R'),
              errorStyle: TextStyle(fontSize: 14.sp, color: const Color(0xffDC3545), fontFamily: 'R'),
              suffixIconConstraints: BoxConstraints(minHeight: 30.h, minWidth: 24.w),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon),
        ),
      ],
    );
  }
}

class TextModel extends GetView {
  const TextModel(
    this.text, {
    Key? key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.height,
    this.fontFamily,
    this.textDecoration,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: TextStyle(
          fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color ?? whiteColor, letterSpacing: letterSpacing, height: height, fontFamily: fontFamily ?? "R", decoration: textDecoration),
    );
  }
}

class BackButtonWidget extends GetView {
  const BackButtonWidget({Key? key, this.onTap, this.margin, this.alignment, this.backGroundColor, this.iconColor, this.svgUrl}) : super(key: key);
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? backGroundColor;
  final Color? iconColor;
  final String? svgUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap ??
            () {
              Get.back();
            },
        child: Container(
          height: 40.w,
          width: 40.w,
          padding: EdgeInsets.all(7.r),
          margin: margin ?? EdgeInsets.only(left: 24.w),
          decoration: BoxDecoration(
            color: backGroundColor ?? themeColor.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(svgUrl ?? Res.arrow_back, color: iconColor),
        ),
      ),
    );
  }
}

class ListTileWidget extends GetView {
  ListTileWidget({Key? key, this.onTap, this.text, this.trailing, this.leading, this.color, this.backgroundColor, this.svgUrl, this.title}) : super(key: key);
  final String? text;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final Widget? title;
  final Color? color;
  final Color? backgroundColor;
  String? svgUrl;

  @override
  Widget build(BuildContext context) {
    if (leading != null) {
      svgUrl = null;
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        margin: EdgeInsets.only(bottom: 10.h),
        height: 50.h,
        width: isTab(context) ? commonWidth(context) : 327.w,
        decoration: BoxDecoration(color: backgroundColor ?? Colors.transparent, borderRadius: BorderRadius.circular(6.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (svgUrl != null) ...[
              Container(
                height: 40.w,
                width: 40.w,
                padding: EdgeInsets.all(11.w),
                decoration: const BoxDecoration(color: pinkColor, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  svgUrl!,
                  color: whiteColor,
                ),
              ),
              SizedBox(width: 10.w)
            ] else ...[
              if (leading == null) ...[
                const SizedBox.shrink()
              ] else ...[
                leading!,
                SizedBox(width: 10.w),
              ]
            ],
            if (title != null) ...[
              SizedBox(width: 10.w),
              title!,
            ] else ...[
              SizedBox(width: 10.w),
              TextModel(text!, fontSize: 16.sp),
            ],
            const Spacer(),
            trailing ?? Icon(Icons.arrow_forward_ios, color: whiteColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

commonHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

commonWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}
