import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/database_helper.dart';
import 'package:test_app/login.dart';
import 'package:test_app/models/userModel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage();

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailContorller = TextEditingController();
  final nickNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final passwordController = TextEditingController();
  final aboutMeController = TextEditingController();
  final pictureController = TextEditingController();

  // type of Uint8List means list of unsigned 8-bit integers
  // often used to store byte data, here we gona save the picture
  Uint8List? _profileImage;

  // Pick the image from gallery and store in [_profileImage] as bytes
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
    }
  }

  // allow the data picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text(
          "Signup Page",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    "Signup Form",
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 228, 206, 7),
                        decoration: TextDecoration.underline),
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      label: Text("first name"),
                      hintText: "Asi",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      label: Text("last name"),
                      hintText: "last name",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nickNameController,
                    decoration: const InputDecoration(
                      label: Text("nickName"),
                      hintText: "Asi123",
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailContorller,
                    decoration: const InputDecoration(
                      label: Text("email"),
                      hintText: "exampleEmail@gmail.com",
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        label: Text("phone"),
                        hintText: "05212345678",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: dateOfBirthController,
                    decoration: const InputDecoration(
                      label: Text("date of birth"),
                      hintText: "01/01/1990",
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: aboutMeController,
                    decoration: const InputDecoration(
                      label: Text("about me"),
                      hintText: "tell about yourself shortly",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "this field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Pick your profile image',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print("form is valid");

                        final db = DatabaseHelper();
                        UserModel user = UserModel(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            nickName: nickNameController.text,
                            email: emailContorller.text,
                            password: passwordController.text,
                            phone: phoneController.text,
                            dateOfBirth: dateOfBirthController.text,
                            aboutMe: aboutMeController.text,
                            pictureUrl: _profileImage,
                            lastEnter: DateTime.now().toString());

                        final result = await db.signup(user);

                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('You signed up successfully')),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Signup Failed"),
                                content: const Text("something went worng..."),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text("OK"),
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
                    child: const Text(
                      "Submit Form",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "already have an account? ",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "login now",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 83, 148),
                              fontSize: 18),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
