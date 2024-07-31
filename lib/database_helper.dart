import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:test_app/models/userModel.dart";

class DatabaseHelper {
  final asiDB = "asiDB";

  String user =
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT NOT NULL, lastName TEXT NOT NULL,nickName TEXT NOT NULL, email TEXT NOT NULL,password TEXT NOT NULL,phone TEXT NOT NULL,dateOfBirth TEXT NOT NULL,aboutMe TEXT NOT NULL,pictureUrl TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

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

  Future<int> signup(UserModel user) async {
    final Database db = await initDB();
    return db.insert("users", user.toJson());
  }

  Future<bool> login(UserModel user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where email = '${user.email}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
