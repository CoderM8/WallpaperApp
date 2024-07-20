import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpapers_hd/api_services/home_services.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/modal/get_category.dart' as get_category;
import 'package:wallpapers_hd/modal/premium_wall_model.dart' as pre_wall;
import 'package:wallpapers_hd/screens/databasefav/db.dart';
import '../../modal/get_home_model.dart';
import '../../modal/get_wallpaper_list.dart' as get_wallList;
import '../../modal/popular_section_model.dart' as pop;
import '../../modal/popular_section_wallpaper_list_model.dart' as pop_wall;

final HomeController homeController = Get.put(HomeController());

RxBool isLoadingGetWallpapers = false.obs;

class HomeController extends GetxController {
  RxList<WallpaperColor> wallpaperColors = <WallpaperColor>[].obs;
  RxBool isLoading = false.obs;
  RxList<Wallpaper> featuredWallpaper = <Wallpaper>[].obs;
  RxList<Wallpaper> latestWallpaper = <Wallpaper>[].obs;
  RxList<Wallpaper> popularWallpaper = <Wallpaper>[].obs;

  Rx<GetHome> getHome = GetHome().obs;
  Rx<get_wallList.GetWallpaperList> getWallPaper = get_wallList.GetWallpaperList().obs;
  RxList<get_wallList.HdWallpaper> getWallPaperList = <get_wallList.HdWallpaper>[].obs;

  Rx<get_wallList.GetWallpaperList> getColorWallPapers = get_wallList.GetWallpaperList().obs;
  RxList<get_wallList.HdWallpaper> getColorWallPapersList = <get_wallList.HdWallpaper>[].obs;
  Rx<get_category.GetCategory> getCatGory = get_category.GetCategory().obs;
  RxList<get_category.HdWallpaper> getCatGoryList = <get_category.HdWallpaper>[].obs;
  Rx<get_wallList.GetWallpaperList> getSingleWallpaper = get_wallList.GetWallpaperList().obs;
  Rx<pop_wall.PopularWallPaperListModel> getPopularSingleWallpaper = pop_wall.PopularWallPaperListModel().obs;
  RxList<pop.HdWallpaper> getPopularSectionList = <pop.HdWallpaper>[].obs;
  RxList<pop_wall.HdWallpaper> getPopularSectionWallpaperList = <pop_wall.HdWallpaper>[].obs;
  RxList<pre_wall.HdWallpaper> getPremiumWallpaperList = <pre_wall.HdWallpaper>[].obs;
  Rx<pre_wall.PremiumWallpaperList> getPremiumWallpaper = pre_wall.PremiumWallpaperList().obs;

  RxBool isFavorite = false.obs;

  RxBool isDownload = false.obs;

  @override
  Future<void> onInit() async {
    Apis().getHomeApi(Page: '1', type: ImageOrientation.All);
    Apis().getWallpaper(
      Page: '1',
    );
    Apis().getCategory();
    Apis().getPopularSection(Page: '1');
    isLoadingGetWallpapers.value = true;
    Apis().get_premium_list(Page: '1', id: '');
    super.onInit();
  }

  getLikeOrNotWall({required String image, required String id}) async {
    if (image.toString().endsWith('gif')) {
      await DBHelper().likeOrNotGif(id: id).then((value) {
        isFavorite.value = value;
      });
    } else {
      await DBHelper().likeOrNotWall(id: id).then((value) {
        isFavorite.value = value;
      });
    }
  }

  Future<void> addToFavorite(context, {required String image, required String title, required String id, required String type, required String isPaid}) async {
    if (image.toString().endsWith('gif')) {
      if (!isFavorite.value) {
        DBHelper().addFavouriteGifs(FavouriteGifs(id: int.parse(id), imageurl: image, name: title));
        showSnackBar(context, msg: "Gif Add in Favourite");
        isFavorite.value = true;
      } else {
        DBHelper().deleteGifs(int.parse(id));
        showSnackBar(context, msg: "Remove From Favourite");
        isFavorite.value = false;
      }
    } else {
      if (!isFavorite.value) {
        print('add wallpaper type ==> $type');
        DBHelper().addFavourite(FavouriteWallpaper(id: int.parse(id), imageurl: image, name: title, type: type, isPaid: isPaid));
        showSnackBar(context, msg: "Add in Favourite");
        isFavorite.value = true;
      } else {
        DBHelper().deleteWallpapers(int.parse(id));
        showSnackBar(context, msg: "Remove From Favourite");
        isFavorite.value = false;
      }
    }
  }

  Future<void> addToDownload(context, {required String image}) async {
    if (userId != null) {
      PermissionStatus status = PermissionStatus.granted;

      if (isAndroidVersionUp13.value) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        showSnackBar(context, msg: "Start downloading");
        isDownload.value = true;
        await GallerySaver.saveImage(image).whenComplete(() {
          isDownload.value = false;
          showSnackBar(context, msg: "Save in Gallery");
        });
      } else {
        showToast(message: 'Permission denied !!');
      }
    } else {
      showToast(message: "Login please!");
    }
  }

  Future<void> addWallpaper({required String image, required LocationType type}) async {
    isLoading.value = true;
    var file = await DefaultCacheManager().getSingleFile(image);
    try {
      await WallpaperManager.setWallpaperFromFile(file.path, type.index + 1);
      showToast(message: "Apply ${type.name.replaceAll('_', ' ')}");
      isLoading.value = false;
      Get.back();
    } on PlatformException catch (e) {
      showToast(message: e.message.toString());
      isLoading.value = false;
    }
  }

  Future<void> removeWallpaper() async {
    try {
      await WallpaperManager.clearWallpaper();
      Get.back();
    } on PlatformException catch (e) {
      showToast(message: e.message.toString());
    }
  }
}

enum ImageOrientation {
  Portrait,
  Landscape,
  Square,
  All,
}

const Map<ImageOrientation, String> orientationStringMap = {
  ImageOrientation.Portrait: 'Portrait',
  ImageOrientation.Landscape: 'Landscape',
  ImageOrientation.Square: 'Square',
  ImageOrientation.All: '',
};

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectionManagerController>(() => ConnectionManagerController());
  }
}

class ConnectionManagerController extends GetxController {
  //0 = No Internet, 1 = WIFI Connected ,2 = Mobile Data Connected.
  var connectionType = 0.obs;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getConnectivityType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
    late List<ConnectivityResult> connectivityResult;
    try {
      connectivityResult = (await (_connectivity.checkConnectivity()));
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return _updateState(connectivityResult);
  }

  _updateState(List<ConnectivityResult> result) {
    switch (result[0]) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;

        break;
      case ConnectivityResult.ethernet:
        connectionType.value = 3;

        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        break;
      default:
        commonSnackBar(title: 'Error', massage: 'Failed to get connection type', backgroundColor: redColor);
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    // commonSnackBar(title: );
  }
}
