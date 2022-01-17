import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

// Wrapper class to contain static DB methods.
class DBHelper {
  static const tableName = "fav_stories";

  // Returns Database instance for other methods to work with.
  static Future<sql.Database> _database() async {
    final dbPath = await sql.getDatabasesPath();
    try {
      return sql.openDatabase(path.join(dbPath, "notes_app.db"),
          onCreate: (db, version) {
        try {
          // Storing only the relevant fields in the database.
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

  // Returns all the rows stored in the database.
  static Future<List<Map<String, Object?>>> getAllFavorites() async {
    final db = await _database();
    return db.query(tableName);
  }

  // Queries the database for a single row based on ID.
  static Future<List<Map<String, Object?>>> getFavoriteById(int storyId) async {
    final db = await _database();
    return db.query(tableName, where: "id = ?", whereArgs: [storyId]);
  }

  // Adds new story to favorites.
  static Future<int> addFavorite(Map<String, Object> vals) async {
    final db = await _database();
    try {
      return db.insert(tableName, vals);
    } catch (err) {
      throw Exception("Error adding Favorite");
    }
  }

  // Removes and existing story from database based on its ID.
  static Future<int> removeFromFavorite(int storyId) async {
    final db = await _database();
    try {
      return db.delete(tableName, where: "id = ?", whereArgs: [storyId]);
    } catch (err) {
      throw Exception("Error deleting from fav.");
    }
  }

  // Returns all the values of ID column. Effectively returning a list of all IDs for favorite stories.
  static Future<List<Map<String, Object?>>> getAllFavIds() async {
    final db = await _database();
    try {
      return db.query(tableName, columns: ["id"]);
    } catch (e) {
      throw Exception("Error fetching all Ids.");
    }
  }
}
