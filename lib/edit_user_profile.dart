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
  late TextEditingController nameController;

  late TextEditingController nickNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dateOfBirthController;
  late TextEditingController aboutMeController;
  late Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
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
    nameController.dispose();
    nickNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Pick image from gallery or camera
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Check the file size
      final fileSize = await pickedFile.length();
      final maxSize = 3.5 * 1024 * 1024; // 3.5 MB in bytes

      if (fileSize > maxSize) {
        // Show an error message if the image is too large
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'The selected image is too large. Please choose an image smaller than 3.5 MB.'),
          ),
        );
        return;
      }
      // Load the image into memory
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
    }
  }

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

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper();
      UserModel updatedUser = UserModel(
        id: widget.user.id,
        name: nameController.text,
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
        backgroundColor: Colors.blue.withOpacity(0.5),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your  name';
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(
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
