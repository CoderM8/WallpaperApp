// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/res.dart';

class CacheImage extends GetView {
  const CacheImage(
      {Key? key,
      required this.imageUrl,
      this.imageType = ImageType.network,
      this.width,
      this.height,
      this.radius,
      this.circle = false,
      this.svgColor})
      : super(key: key);
  final String imageUrl;
  final double? height;
  final double? width;
  final double? radius;
  final bool? circle;
  final Color? svgColor;
  final ImageType? imageType;

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.asset:
        {
          return Container(
            height: height ?? 200.w,
            width: width ?? 200.w,
            decoration: circle == true
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(imageUrl), fit: BoxFit.cover),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(radius ?? 8.r),
                    image: DecorationImage(
                        image: AssetImage(imageUrl), fit: BoxFit.cover),
                  ),
          );
        }
      case ImageType.network:
        {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            height: height ?? 200.w,
            width: width ?? 200.w,
            imageBuilder: (context, image) => Container(
              height: height ?? 200.w,
              width: width ?? 200.w,
              decoration: circle == true
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(radius ?? 8.r),
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                    ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                height: height ?? 200.w,
                width: width ?? 200.w,
                decoration: circle == true
                    ? const BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeColor,
                        image: DecorationImage(
                            image: AssetImage(Res.image_not_found),
                            fit: BoxFit.cover),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(radius ?? 8.r),
                        color: themeColor,
                        image: const DecorationImage(
                            image: AssetImage(Res.image_not_found),
                            fit: BoxFit.cover),
                      ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: height ?? 200.w,
              width: width ?? 200.w,
              decoration: circle == true
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(Res.image_not_found),
                          fit: BoxFit.cover),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(radius ?? 8.r),
                      image: const DecorationImage(
                          image: AssetImage(Res.image_not_found),
                          fit: BoxFit.cover),
                    ),
            ),
          );
        }
      case ImageType.file:
        {
          return Container(
            height: height ?? 200.w,
            width: width ?? 200.w,
            decoration: circle == true
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(File(imageUrl)), fit: BoxFit.cover),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(radius ?? 8.r),
                    image: DecorationImage(
                        image: FileImage(File(imageUrl)), fit: BoxFit.cover),
                  ),
          );
        }
      default:
        {
          return const SizedBox.shrink();
        }
    }
  }
}
