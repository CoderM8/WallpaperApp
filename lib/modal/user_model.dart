import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final List<HdWallpaper> hdWallpaper;

  UserModel({
    required this.hdWallpaper,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        hdWallpaper: List<HdWallpaper>.from(
            json["HD_WALLPAPER"].map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": List<dynamic>.from(hdWallpaper.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  final String success;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String image;

  HdWallpaper({
    required this.success,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        success: json["success"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"] ?? '',
        image: json["user_image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "user_image": image,
      };
}
