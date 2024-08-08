import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/database_helper.dart';
import 'package:test_app/edit_user_profile.dart';
import 'package:test_app/login.dart';
import 'package:test_app/models/userModel.dart';
import 'package:test_app/userProfileWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UserModel>> users;
  UserModel? currentUser;
  // ngOnInit on the 1st time rendering do all methods belows
  @override
  void initState() {
    super.initState();
    getUsers();
    _loadCurrentUser();
  }

  getUsers() async {
    final db = DatabaseHelper();
    users = db.getAllUsers();
    setState(() {});
  }

  void _loadCurrentUser() async {
    DatabaseHelper db = DatabaseHelper();
    UserModel? user = await db.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  int _calculateAge(String dateString) {
    final birthDate = DateTime.parse(dateString);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Clear SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              // Perform logout and navigate to login page remove all other pages we have been
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Remove all previous routes
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("no data"),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error.toString()}");
              } else {
                final users = snapshot.data ?? <UserModel>[];
                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final dateOfBirth = user.dateOfBirth;
                      final age = dateOfBirth != null
                          ? _calculateAge(dateOfBirth)
                          : "Unknown";
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileWidget(
                                  user: users[index],
                                  currentUser: currentUser ??
                                      UserModel(email: '', password: ''),
                                ),
                              ),
                            );
                            // set state - update the the state of the screen and update the all screen accordingly
                            setState(() {
                              getUsers();
                            });
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(users[index].email),
                              leading: (user.pictureUrl != null)
                                  ? ClipOval(
                                      child: Container(
                                        width: 80, // Circle diameter
                                        height: 80, // Circle diameter
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image:
                                                MemoryImage(user.pictureUrl!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Container(
                                        width: 80, // Circle diameter
                                        height: 80,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'lib/assets/goodLife.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              subtitle: Text(users[index].nickName ?? ""),
                              trailing: Text("Age: $age"),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileWidget(
                    user: currentUser!,
                    currentUser: currentUser!,
                  ),
                ),
              );
            },
            child: Text("my profile"),
          )
        ],
      ),
    ));
  }
}
