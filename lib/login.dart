import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_app/signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String str = "24";

  @override
  Widget build(BuildContext context) {
    log("refresh");
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 203, 220, 1).withOpacity(0.8),
      appBar: AppBar(
        title: Text(
          "Login/Signup",
          style: TextStyle(
              color: Colors.blue.withOpacity(0.8),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(str),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  str = "hello";
                });

                log("str value = ${str}");
              },
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                log("signup button");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text("Signup"),
            )
          ],
        ),
      ),
    );
  }
}
