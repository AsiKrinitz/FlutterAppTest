import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/database_helper.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  getUsers() async {
    final db = DatabaseHelper();
    users = db.getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.withOpacity(0.5),
        centerTitle: true,
        title: Text(
          "Home Page",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Perform logout and navigate to login page
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
                return CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileWidget(
                                  user: users[index],
                                  //  currentUser: currentUser,
                                ),
                              ),
                            );
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
                                        decoration: BoxDecoration(
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
        ],
      ),
    ));
  }
}

void test() {
  log("hey");
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
