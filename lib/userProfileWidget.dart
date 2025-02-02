import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/login.dart';
import 'package:test_app/models/userModel.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key, required this.user});

  final UserModel user;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            (user.pictureUrl != null)
                ? ClipOval(
                    child: Container(
                      width: 120, // Circle diameter
                      height: 120, // Circle diameter
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(user.pictureUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : ClipOval(
                    child: Container(
                      width: 120, // Circle diameter
                      height: 120,
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
            SizedBox(height: 20),
            Text(
              user.nickName ?? "",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.person, "ID", user.id.toString()),
                    _buildInfoRow(Icons.person_outline, "First Name",
                        user.firstName ?? ""),
                    _buildInfoRow(
                        Icons.person_outline, "Last Name", user.lastName ?? ""),
                    _buildInfoRow(Icons.email, "Email", user.email ?? ""),
                    _buildInfoRow(Icons.phone, "Phone", user.phone ?? ""),
                    _buildInfoRow(
                        Icons.cake, "Date of Birth", user.dateOfBirth ?? ""),
                    _buildInfoRow(Icons.info, "About Me", user.aboutMe ?? ""),
                    // _buildInfoRow(Icons.calendar_today, "Created At",
                    //     _formatDate(user.createdAt ?? "")),
                    _buildInfoRow(Icons.login, "Last Enter",
                        _formatDate(user.lastEnter ?? "")),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Edit Profile"))
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, y h:mm a').format(date);
    } catch (e) {
      return "Invalid date";
    }
  }
}
