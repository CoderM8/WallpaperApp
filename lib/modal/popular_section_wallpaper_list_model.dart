// To parse this JSON data, do
//
//     final popularWallPaperListModel = popularWallPaperListModelFromJson(jsonString);

import 'dart:convert';

PopularWallPaperListModel popularWallPaperListModelFromJson(String str) => PopularWallPaperListModel.fromJson(json.decode(str));

String popularWallPaperListModelToJson(PopularWallPaperListModel data) => json.encode(data.toJson());

class PopularWallPaperListModel {
  List<HdWallpaper>? hdWallpaper;

  PopularWallPaperListModel({
    this.hdWallpaper,
  });

  factory PopularWallPaperListModel.fromJson(Map<String, dynamic> json) => PopularWallPaperListModel(
        hdWallpaper: json["HD_WALLPAPER"] == null ? [] : List<HdWallpaper>.from(json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null ? [] : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? num;
  String? id;
  String? pWallpaperName;
  String? pWallpaperImage;
  String? popularId;
  String? isPaid;
  String? pWallpaperStatus;
  String? popularView;
  String? popularDownload;
  String? popularSectionName;

  HdWallpaper({
    this.num,
    this.id,
    this.pWallpaperName,
    this.pWallpaperImage,
    this.popularId,
    this.isPaid,
    this.pWallpaperStatus,
    this.popularView,
    this.popularDownload,
    this.popularSectionName,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        num: json["num"],
        id: json["id"],
        pWallpaperName: json["p_wallpaper_name"],
        pWallpaperImage: json["p_wallpaper_image"],
        popularId: json["popular_id"],
        isPaid: json["is_paid"],
        pWallpaperStatus: json["p_wallpaper_status"],
        popularView: json["popular_view"],
        popularDownload: json["popular_download"],
        popularSectionName: json["popular_section_name"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "id": id,
        "p_wallpaper_name": pWallpaperName,
        "p_wallpaper_image": pWallpaperImage,
        "popular_id": popularId,
        "p_wallpaper_status": pWallpaperStatus,
        "is_paid": isPaid,
        "popular_view": popularView,
        "popular_download": popularDownload,
        "popular_section_name": popularSectionName,
      };
}
