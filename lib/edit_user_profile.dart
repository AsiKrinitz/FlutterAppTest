import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/models/userModel.dart';
import 'package:test_app/database_helper.dart'; // Import the DatabaseHelper

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController nickNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dateOfBirthController;
  late TextEditingController aboutMeController;
  late Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    nickNameController = TextEditingController(text: widget.user.nickName);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    dateOfBirthController =
        TextEditingController(text: widget.user.dateOfBirth);
    aboutMeController = TextEditingController(text: widget.user.aboutMe);
    _profileImage = widget.user.pictureUrl;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nickNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _profileImage = imageBytes;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper();
      UserModel updatedUser = UserModel(
        id: widget.user.id,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        nickName: nickNameController.text,
        email: widget.user.email,
        password: widget.user.password,
        phone: phoneController.text,
        dateOfBirth: dateOfBirthController.text,
        aboutMe: aboutMeController.text,
        pictureUrl: _profileImage,
        lastEnter: widget.user.lastEnter, // Keep the lastEnter value
      );
      await db.updateUser(updatedUser); // Update user in the database

      Navigator.pop(
          context, updatedUser); // Pass updated user back to profile page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nickNameController,
                decoration: InputDecoration(labelText: 'Nick Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nick name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                enabled: false, // Make email field uneditable
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateOfBirthController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(labelText: 'About Me'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some information about yourself';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
                      : Image.asset('lib/assets/goodLife.jpg'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
