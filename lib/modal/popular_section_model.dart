// To parse this JSON data, do
//
//     final popularSectionModel = popularSectionModelFromJson(jsonString);

import 'dart:convert';

PopularSectionModel popularSectionModelFromJson(String str) => PopularSectionModel.fromJson(json.decode(str));

String popularSectionModelToJson(PopularSectionModel data) => json.encode(data.toJson());

class PopularSectionModel {
  List<HdWallpaper>? hdWallpaper;

  PopularSectionModel({
    this.hdWallpaper,
  });

  factory PopularSectionModel.fromJson(Map<String, dynamic> json) => PopularSectionModel(
        hdWallpaper: json["HD_WALLPAPER"] == null ? [] : List<HdWallpaper>.from(json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null ? [] : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? num;
  String? wallCount;
  String? id;
  String? isPaid;
  String? popularName;
  String? popularStatus;
  String? popularImage;
  String? popularImageThumbs;

  HdWallpaper({
    this.num,
    this.wallCount,
    this.id,
    this.isPaid,
    this.popularName,
    this.popularStatus,
    this.popularImage,
    this.popularImageThumbs,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        num: json["num"],
        wallCount: json["wall_count"],
        id: json["id"],
        popularName: json["popular_name"],
        isPaid: json["is_paid"],
        popularStatus: json["popular_status"],
        popularImage: json["popular_image"],
        popularImageThumbs: json["popular_image_thumbs"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "wall_count": wallCount,
        "id": id,
        "popular_name": popularName,
        "is_paid": isPaid,
        "popular_status": popularStatus,
        "popular_image": popularImage,
        "popular_image_thumbs": popularImageThumbs,
      };
}
