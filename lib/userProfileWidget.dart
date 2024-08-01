import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/userModel.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key, required this.user});

  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Text(user.id.toString()),
          Text(user.firstName ?? ""),
          Text(user.lastName ?? ""),
          Text(user.nickName ?? ""),
          Text(user.email ?? ""),
          Text(user.phone ?? ""),
          Text(user.dateOfBirth ?? ""),
          Text(user.aboutMe ?? ""),
          // Text(user.pictureUrl ?? ""),
          Text(user.createdAt.toString()),
          Text(user.lastEnter.toString())
        ],
      ),
    );
  }
}
