import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class DatabaseHelper {
  final asiDB = "asiDB";

  String user =
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT NOT NULL, lastName TEXT NOT NULL, email TEXT NOT NULL,password TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, asiDB);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(user);
      },
    ).whenComplete(() {
      print("database open successfully");
    });
  }

  Future signup() async {
    

  }
}
