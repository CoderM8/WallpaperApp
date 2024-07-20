import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpapers_hd/constant.dart';

enum ImageType { asset, network, file }

enum LocationType { HOME_SCREEN, LOCK_SCREEN, BOTH_SCREEN }

String formatFollowerCount(int count) {
  if (count < 1000) {
    return '$count';
  } else if (count < 1000000) {
    double num = count / 1000.0;
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}K';
  } else if (count < 1000000000) {
    double num = count / 1000000.0;
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}M';
  } else {
    double num = count / 1000000000.0;
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}B';
  }
}

bool isTab(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 600 && MediaQuery.sizeOf(context).width < 2048;
}

Stream<PaletteGenerator> getDominantColorStreamFromCachedNetworkImage(
  CachedNetworkImageProvider imageProvider,
) {
  return Stream.fromFuture(PaletteGenerator.fromImageProvider(imageProvider).then((generator) => generator));
}

Widget commonShimmer() {
  return Shimmer.fromColors(
    child: Container(
      color: Colors.white,
    ),
    baseColor: themeColor.withOpacity(0.5),
    highlightColor: greyColor.withOpacity(0.7),
  );
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

bool isPaidWallpaper(String isPaid) {
  return isPaid == '1' ? true : false;
}

SnackbarController commonSnackBar({
  String? title,
  String? massage,
  Widget? icon,
  Color? backgroundColor,
  double? borderRadius,
  Duration? duration,
  Color? textColor,
  bool? isDismissible,
  EdgeInsets? margin,
}) {
  return Get.snackbar(
    title ?? "",
    massage ?? "",
    icon: icon,
    snackPosition: SnackPosition.TOP,
    backgroundColor: backgroundColor ?? redColor,
    borderRadius: borderRadius ?? 12,
    margin: margin ?? const EdgeInsets.all(12),
    colorText: textColor ?? Colors.white,
    duration: duration ?? const Duration(seconds: 3),
    isDismissible: isDismissible ?? true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
