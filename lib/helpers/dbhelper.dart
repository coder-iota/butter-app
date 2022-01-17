import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const tableName = "fav_stories";

  static Future<sql.Database> _database() async {
    final dbPath = await sql.getDatabasesPath();
    try {
      return sql.openDatabase(path.join(dbPath, "notes_app.db"),
          onCreate: (db, version) {
        try {
          return db.execute(
              'CREATE TABLE ${DBHelper.tableName}( id INTEGER PRIMARY KEY, by TEXT, title TEXT, url TEXT, time TEXT)');
        } catch (err) {
          throw Exception("Error Creating DB");
        }
      }, version: 1);
    } catch (err) {
      throw Exception("ERROR Opening DB");
    }
  }

  static Future<List<Map<String, Object?>>> getAllFavorites() async {
    final db = await _database();
    return db.query(tableName);
  }

  static Future<List<Map<String, Object?>>> getFavoriteById(int storyId) async {
    final db = await _database();
    return db.query(tableName, where: "id = ?", whereArgs: [storyId]);
  }

  static Future<int> addFavorite(Map<String, Object> vals) async {
    final db = await _database();
    try {
      return db.insert(tableName, vals);
    } catch (err) {
      throw Exception("Error adding Favorite");
    }
  }

  static Future<int> removeFromFavorite(int storyId) async {
    final db = await _database();
    try {
      return db.delete(tableName, where: "id = ?", whereArgs: [storyId]);
    } catch (err) {
      throw Exception("Error deleting from fav.");
    }
  }

  static Future<List<Map<String, Object?>>> getAllFavIds() async {
    final db = await _database();
    try {
      return db.query(tableName, columns: ["id"]);
    } catch (e) {
      throw Exception("Error fetching all Ids.");
    }
  }
}
