import "package:path/path.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sqflite/sqflite.dart";
import "package:test_app/models/userModel.dart";

class DatabaseHelper {
  final asiDB = "asiDB";

  String user = """
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL, 
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
    return result.isNotEmpty; // if email exist return true else return false
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

  Future<bool> login(UserModel user) async {
    final Database db = await initDB();

    // Fetch the user based on email and password
    List<Map<String, dynamic>> users = await db.query(
      'users',
      columns: ['email', 'password'], // Select only the necessary columns
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

      // Store user info in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Store email as an identifier in the cache memory/preferences
      // as key and value when current user is the key and the value is the email.
      await prefs.setString('currentUser', user.email);

      return true;
    }
    return false;
  }

  Future<List<UserModel>> getAllUsers() async {
    final Database db = await initDB();
    // Order by lastEnter DESC to get the most recent users first
    List<Map<String, Object?>> result = await db.query(
      "users",
      orderBy: "lastEnter DESC",
    );
    // deserialize the object from json to UserModel
    return result.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<UserModel?> getCurrentUser() async {
    // here we are getting the current user email that we store in a cache meomory
    // like local storage in web
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('currentUser');

    // here we check if email is not null then we will pass this email to the users table
    // to see if there is any matching email, if the email is match with any user it will return the user.
    if (email != null) {
      final Database db = await initDB();
      List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (users.isNotEmpty) {
        return UserModel.fromJson(users.first);
      }
    }
    return null;
  }

  updateUserLastEnter(UserModel user) async {
    final Database db = await initDB();
    return db.rawUpdate("UPDATE users set lastEnter = ?, where email =? ",
        [user.lastEnter, user.email]);
  }

  Future<void> updateUser(UserModel user) async {
    final Database db = await initDB();
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
