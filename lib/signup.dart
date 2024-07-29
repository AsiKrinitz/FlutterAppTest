import 'dart:developer';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage();

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailContorller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.5),
      appBar: AppBar(
        title: const Text(
          "Signup Page",
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.indigo,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Signup Form",
                style: TextStyle(
                    fontSize: 40,
                    color: const Color.fromARGB(255, 228, 206, 7),
                    decoration: TextDecoration.underline),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                    label: Text("first name"),
                    hintText: "Asi",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailContorller,
                decoration: InputDecoration(
                    label: Text("email"),
                    hintText: "exampleEmail@gmail.com",
                    border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    print("your first name is ${firstNameController.text}");
                    print("your email is ${emailContorller.text}");
                  },
                  child: Text(
                    "Submit Form",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
