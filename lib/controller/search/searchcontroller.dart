import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/modal/search_gif_model.dart';

import '../../api_services/home_services.dart';
import '../home/homecontroller.dart';
import '../../modal/get_wallpaper_list.dart' as get_wallList;

MySearchController searchController = Get.put(MySearchController());

class MySearchController extends GetxController {
  RxBool isSearch = false.obs;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Rx<Gif> searchGif = Gif().obs;
  RxList<HdWallpaper> searchGifList = <HdWallpaper>[].obs;
  Rx<get_wallList.GetWallpaperList> searchWallPaper = get_wallList.GetWallpaperList().obs;
  RxList<get_wallList.HdWallpaper> searchWallpaperList = <get_wallList.HdWallpaper>[].obs;

  void onUserSearch() {
    print('hello this is first api call');
    Apis().getUserSearchGif(text: '', Page: 1.toString());
    Apis().getUserSearchWallpaper(text: '', Page: 1.toString(), type: ImageOrientation.Portrait);
  }

  @override
  void onReady() {
    onUserSearch();
    super.onReady();
  }
}
