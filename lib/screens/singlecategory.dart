import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';


class SingleCategory extends GetView {
  SingleCategory({required this.cid, required this.title});

  final String cid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            BackButtonWidget(backGroundColor: pinkColor, iconColor: whiteColor),
        title: TextModel(title, fontFamily: 'M', fontSize: 20.sp),
        leadingWidth: 60.w,
      ),
      // body: FutureBuilder(
      //     future: HomeServices.getCategoryById(cid: cid,Page: 1.toString(),type: ImageOrientation.Portrait),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      //           return GridView.builder(
      //             shrinkWrap: true,
      //             padding: EdgeInsets.all(10.w),
      //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 childAspectRatio: 200 / 250, crossAxisCount: 3, mainAxisSpacing: 10.w, crossAxisSpacing: 10.w),
      //             itemCount: snapshot.data!.length,
      //             itemBuilder: (context, index) {
      //               final String image = snapshot.data![index]["wallpaper_image"];
      //               return GestureDetector(
      //                 onTap: () {
      //                   Get.to(() => SingleWallpaper(
      //                       wall: List.generate(
      //                           snapshot.data!.length,
      //                           (i) => Wall(
      //                               id: snapshot.data![i]["id"],
      //                               title: snapshot.data![i]["category_name"],
      //                               image: snapshot.data![i]["wallpaper_image"])),
      //                       index: index));
      //                 },
      //                 child: CacheImage(imageUrl: image, radius: 10.r),
      //               );
      //             },
      //           );
      //         } else {
      //           return Center(child: TextModel('No wallpaper', fontSize: 18.sp, fontFamily: 'M'));
      //         }
      //       } else {
      //         return GridView.builder(
      //           shrinkWrap: true,
      //           padding: EdgeInsets.all(10.w),
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //               childAspectRatio: 200 / 250, crossAxisCount: 3, mainAxisSpacing: 10.w, crossAxisSpacing: 10.w),
      //           itemCount: 6,
      //           itemBuilder: (context, index) {
      //             return Shimmer.fromColors(
      //               highlightColor: highlightColor,
      //               baseColor: baseColor,
      //               child: CacheImage(imageUrl: '', radius: 10.r),
      //             );
      //           },
      //         );
      //       }
      //     }),
    );
  }
}
