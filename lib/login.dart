import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/database_helper.dart';
import 'package:test_app/home.dart';
import 'package:test_app/models/userModel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text("email"),
                      hintText: "your email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: Text("password"),
                      hintText: "",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else if (value.length < 5) {
                        return "Password must be at least 5 characters long";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final db = DatabaseHelper();
                        UserModel user = UserModel(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        try {
                          var response = await db.login(user);
                          if (response == true) {
                            print("logged in in successfully");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("logged in successfully"),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          } else {
                            print("something went wrong...");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Login Failed"),
                                  content: Text(
                                      "The email or password is incorrect. Please try again."),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          print("Error: $e");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(
                                    "An unexpected error occurred. Please try again later."),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text("Login"),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
