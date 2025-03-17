import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../login/start_login.dart';

class StudentManageAccount extends StatefulWidget {
  const StudentManageAccount({super.key});

  @override
  State<StudentManageAccount> createState() => _StudentManageAccountState();
}

class _StudentManageAccountState extends State<StudentManageAccount> {
  String? accessLoginToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
  }

  Future<void> logoutUser() async {
    final url = Uri.parse("https://admin.uthix.com/api/logout");

    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessLoginToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        log("Logout successful");

        // Clear shared preferences
        await prefs.clear();
        log("SharedPreferences cleared successfully");

        // Ensure widget is still mounted before navigating
        if (!context.mounted) return;

        // Navigate to StartLogin screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartLogin()),
        );
      } else {
        log("Logout failed: ${response.body}");
      }
    } catch (e) {
      log("Error logging out: $e");
    }
  }

  // Logout Confirmation Dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                // Clear token and logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                log("SharedPreferences cleared successfully");

                // Call the logout function to handle API logout
                logoutUser();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red), // Highlight logout button
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Manage your Account",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    "assets/Seller_dashboard_images/ManageStoreBackground.png"), // Replace with network image if needed
              ),
              const SizedBox(height: 10),
              const Text(
                "Mahima Mandal",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B5C74),
                ),
              ),
              const Text(
                "Class X B\nDelhi Public School, New Delhi\n+91 XXXXXX XXXXX",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Urbanist",
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),

              // Text Fields
              _buildProfileField(Icons.person, "Mahima"),
              _buildProfileField(Icons.phone, "+91 XXXXXX XXXXX"),
              _buildProfileField(Icons.location_on, "IP Extension, New Delhi"),
              _buildProfileField(Icons.school, "Banaras Hindu University"),

              const SizedBox(height: 30),

              // Logout Button with Popup
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showLogoutDialog(context); // Show confirmation popup
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Urbanist",
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Add Account",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Urbanist",
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFFCFCFC),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: Color(0xFF605F5F),
            fontWeight: FontWeight.w500,
          ),
          enabled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Color(0xFFD2D2D2),
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Color(0xFFD2D2D2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
