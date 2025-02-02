import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:test_app/models/userModel.dart";

class DatabaseHelper {
  final asiDB = "asiDB";

  String user = """
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      firstName TEXT NOT NULL, 
      lastName TEXT NOT NULL, 
      nickName TEXT NOT NULL, 
      email TEXT NOT NULL UNIQUE, 
      password TEXT NOT NULL, 
      phone TEXT NOT NULL, 
      dateOfBirth TEXT NOT NULL, 
      aboutMe TEXT NOT NULL, 
      pictureUrl BLOB, 
      lastEnter TEXT NOT NULL, 
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP
    )
  """;

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

  Future<bool> isEmailRegistered(String email) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<String?> signup(UserModel user) async {
    final Database db = await initDB();

    // Check if email is already registered
    if (await isEmailRegistered(user.email)) {
      return 'This email is already registered. Please use another one.';
    } else {
      // Insert new user
      await db.insert("users", user.toJson());
      return null;
    }
  }

  // Future<bool> login2(UserModel user) async {
  //   final Database db = await initDB();
  //   var result = await db.rawQuery(
  //       "select * from users where email = '${user.email}' AND password = '${user.password}'");
  //   if (result.isNotEmpty) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> login(UserModel user) async {
    final Database db = await initDB();

    // Fetch the user based on email and password
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [user.email, user.password],
    );

    if (users.isNotEmpty) {
      // User found, update the lastEnter value
      await db.update(
        'users',
        {'lastEnter': DateTime.now().toIso8601String()},
        where: 'email = ?',
        whereArgs: [user.email],
      );
      return true;
    }
    return false;
  }

  Future<List<UserModel>> getAllUsers() async {
    final Database db = await initDB();
    // Order by createdAt DESC to get the most recent users first
    List<Map<String, Object?>> result = await db.query(
      "users",
      orderBy: "createdAt DESC",
    );
    return result.map((user) => UserModel.fromJson(user)).toList();
  }

  updateUserLastEnter(UserModel user) async {
    final Database db = await initDB();
    return db.rawUpdate("UPDATE users set lastEnter = ?, where email =? ",
        [user.lastEnter, user.email]);
  }
}
