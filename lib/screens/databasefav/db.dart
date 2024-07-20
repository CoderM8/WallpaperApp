import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    var documentDirectory = await getDatabasesPath();
    String path = join(documentDirectory, 'wallpaperHD.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE wallpaperHD (id INTEGER, imageurl TEXT, name TEXT, type TEXT, is_paid TEXT,PRIMARY KEY(id AUTOINCREMENT))');
    await db.execute('CREATE TABLE gifHD (id INTEGER, imageurl TEXT, name TEXT,PRIMARY KEY(id AUTOINCREMENT))');
    print('table create ');
  }

  //add favourite wallpaper
  addFavourite(FavouriteWallpaper wall) async {
    var dbClient = await db;

    print('wallpaper add successfully...');
    return await dbClient!.insert('wallpaperHD', wall.toMap());
  }

  //fav gifs
  addFavouriteGifs(FavouriteGifs gif) async {
    var dbClient = await db;

    print('gif add successfully...');
    return await dbClient!.insert('gifHD', gif.toMap());
  }

// get Favourite wallpaper
  Future<List<FavouriteWallpaper>> getFavouriteWallpapers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('wallpaperHD');
    List<FavouriteWallpaper> wallpaper = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        wallpaper.add(FavouriteWallpaper.fromMap(maps[i]));
      }
    }
    return wallpaper;
  }

// // get Favourite wallpaper
//   Stream<List<FavouriteWallpaper>> getFavouriteWallpaperStream() async* {
//     final dbClient = await db;
//     yield await dbClient!.query('wallpaperHD').then((maps) => maps.isEmpty
//         ? []
//         : maps.map((map) => FavouriteWallpaper.fromMap(map)).toList());
//   }

//get Favourite gifs
  Future<List<FavouriteGifs>> getFavouriteGifs() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('gifHD');
    List<FavouriteGifs> favourites = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        favourites.add(FavouriteGifs.fromMap(maps[i]));
      }
    }
    return favourites;
  }

  Future<bool> likeOrNotWall({required String id}) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('wallpaperHD', where: 'id = ?', whereArgs: [id]);
    return maps.length > 0 ? true : false;
  }

  Future<bool> likeOrNotGif({required String id}) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('gifHD', where: 'id = ?', whereArgs: [id]);
    return maps.length > 0 ? true : false;
  }

  //del Favourite wallpaper
  Future<int> deleteWallpapers(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('wallpaperHD', where: 'id = ?', whereArgs: [id]);
  }

  //del Favourite gifs
  Future<int> deleteGifs(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('gifHD', where: 'id = ?', whereArgs: [id]);
  }

//update favourite wallpaper
  Future<int> updateFavouriteWallpaper(FavouriteWallpaper wallpaper) async {
    var dbClient = await db;
    return await dbClient!.update('wallpaperHD', wallpaper.toMap(), where: 'id = ?', whereArgs: [wallpaper.id]);
  }

//update favourite gif
  Future<int> updateFavouriteGifs(FavouriteGifs favourite) async {
    var dbClient = await db;
    return await dbClient!.update('gifHD', favourite.toMap(), where: 'id = ?', whereArgs: [favourite.id]);
  }
}

class FavouriteWallpaper {
  final int id;
  final String name;
  final String isPaid;
  final String imageurl;
  final String type;

  FavouriteWallpaper({required this.id, required this.name, required this.imageurl, required this.type, required this.isPaid});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'imageurl': imageurl, 'type': type,'is_paid':isPaid};

  factory FavouriteWallpaper.fromMap(Map<String, dynamic> map) => FavouriteWallpaper(id: map['id'], name: map['name'], imageurl: map['imageurl'], type: map['type'], isPaid: map['is_paid']);
}

class FavouriteGifs {
  final int id;
  final String name;
  final String imageurl;

  FavouriteGifs({required this.id, required this.name, required this.imageurl});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'imageurl': imageurl};

  factory FavouriteGifs.fromMap(Map<String, dynamic> map) => FavouriteGifs(id: map['id'], name: map['name'], imageurl: map['imageurl']);
}
