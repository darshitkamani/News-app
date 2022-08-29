import 'package:news_app/utils/database/database_utils.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHepler {
  static late Database database;

  Future<Database> intiDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}favorite.db';

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE ${DBUtils.favoriteTable} (${DBUtils.favoriteId} INTEGER PRIMARY KEY, ${DBUtils.favoriteNewsId} INTEGER,${DBUtils.favoriteTitle} TEXT,${DBUtils.favoriteContent} TEXT,${DBUtils.favoriteDescrition} TEXT,${DBUtils.favoriteImage} TEXT)');
    });
    return database;
  }

  void clearDatabase() {
    database.delete(DBUtils.favoriteTable);
  }
}
