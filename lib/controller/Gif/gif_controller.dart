import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/api_services/home_services.dart';

import '../../modal/search_gif_model.dart';

GifController gifController = Get.put(GifController());

class GifController extends GetxController {
  RxInt latestPage = 1.obs;
  RxInt allPage = 1.obs;

  Rx<Gif> latestGif = Gif().obs;
  RxList<HdWallpaper> latestGifList = <HdWallpaper>[].obs;
  ScrollController latestScrollController = ScrollController();
  Rx<Gif> allGif = Gif().obs;
  RxList<HdWallpaper> allGifList = <HdWallpaper>[].obs;
  ScrollController allScrollController = ScrollController();
  Rx<Gif> getSingleGif = Gif().obs;

  @override
  void onReady() {
    Apis().getLatestGif(Page: 1.toString());
    Apis().getAllGif(Page: 1.toString());
    super.onReady();
  }
}
