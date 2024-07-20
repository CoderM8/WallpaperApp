// To parse this JSON data, do
//
//     final getCategory = getCategoryFromJson(jsonString);

import 'dart:convert';

GetCategory getCategoryFromJson(String str) =>
    GetCategory.fromJson(json.decode(str));

String getCategoryToJson(GetCategory data) => json.encode(data.toJson());

class GetCategory {
  List<HdWallpaper>? hdWallpaper;

  GetCategory({
    this.hdWallpaper,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
        hdWallpaper: json["HD_WALLPAPER"] == null
            ? []
            : List<HdWallpaper>.from(
                json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null
            ? []
            : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? cid;
  String? categoryName;
  String? categoryImage;
  String? categoryTotalWall;

  HdWallpaper({
    this.cid,
    this.categoryName,
    this.categoryImage,
    this.categoryTotalWall,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        cid: json["cid"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        categoryTotalWall: json["category_total_wall"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
        "category_image": categoryImage,
        "category_total_wall": categoryTotalWall,
      };
}
