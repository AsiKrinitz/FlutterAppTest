import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_app/login.dart';
import 'package:test_app/signup.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    log("refresh");
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 203, 220, 1).withOpacity(0.8),
      appBar: AppBar(
        title: Text(
          "Welcome Page",
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
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
