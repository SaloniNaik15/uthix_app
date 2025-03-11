import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:uthix_app/view/homeRegistration/registration.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  String? accessToken;

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
    // ✅ Password now saved
    String? savedaccessToken = prefs.getString("userToken");

    log("Retrieved acesstoken: $savedaccessToken");

    setState(() {
      accessToken = savedaccessToken ?? "No accesstoken";
    });
  }

  Future<void> logoutUser() async {
    final url = Uri.parse("https://admin.uthix.com/api/logout");

    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        log("Logout successful");

        // Clear shared preferences
        await prefs.remove("userToken");
        await prefs.remove("userEmail");
        await prefs.remove("password");
        await prefs.remove("userRole");
        await prefs.remove("userName");
        log("SharedPreferences cleared successfully");

        // Navigate to RegistrationPage
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Registration()),
          );
        }
      } else {
        log("Logout failed: ${response.body}");
      }
    } catch (e) {
      log("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF605F5F)),
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
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: logoutUser,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
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
            ],
          ),
        ),
      ),
    );
  }

  // Function to build profile fields
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
