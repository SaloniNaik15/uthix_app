import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentManageAccount extends StatefulWidget {
  const StudentManageAccount({super.key});

  @override
  State<StudentManageAccount> createState() => _StudentManageAccountState();
}

class _StudentManageAccountState extends State<StudentManageAccount> {
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
                backgroundImage: AssetImage("assets/Seller_dashboard_images/ManageStoreBackground.png"), // Replace with network image if needed
              ),
              const SizedBox(height: 10),
              const Text(
                "Mahima Mandal",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF2B5C74),
                ),
              ),
              const Text(
                "Class X B\nDelhi Public School, New Delhi\n+91 XXXXXX XXXXX",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontFamily: "Urbanist",fontWeight: FontWeight.w400),
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
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(color: Colors.red,fontFamily: "Urbanist", fontSize: 16),
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
                        style: TextStyle(color: Colors.black, fontFamily: "Urbanist",fontSize: 16),
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
            color:  Colors.grey,
          ),
          hintText: text,
          hintStyle: TextStyle(
            color:  Color(0xFF605F5F),
            fontWeight: FontWeight.w500,
          ),
          enabled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color:  Color(0xFFD2D2D2),
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color:  Color(0xFFD2D2D2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

}
