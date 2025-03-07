import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;
  bool isOptimizedExperienceEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title "Settings"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Divider below title
          Divider(thickness: 1, color: Colors.grey[300]),

          // First Checkbox ListTile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CheckboxListTile(
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 16, fontFamily: "Urbanist",fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                "This will not affect any order updates",
                style: TextStyle(fontSize: 14, fontFamily: "Urbanist",fontWeight: FontWeight.w400),
              ),
              value: isNotificationsEnabled,
              onChanged: (bool? newValue) {
                setState(() {
                  isNotificationsEnabled = newValue!;
                });
              },
              activeColor: Colors.blue,
            ),
          ),

          // Divider below checkbox
          Divider(thickness: 1, color: Colors.grey[300]),

          // Second Checkbox ListTile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CheckboxListTile(
              title: const Text(
                "Optimized Experience",
                style: TextStyle(fontSize: 16,fontFamily: "Urbanist",fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                "For optimized connection quality",
                style: TextStyle(fontSize: 14,  fontFamily: "Urbanist",fontWeight: FontWeight.w400),
              ),
              value: isOptimizedExperienceEnabled,
              onChanged: (bool? newValue) {
                setState(() {
                  isOptimizedExperienceEnabled = newValue!;
                });
              },
              activeColor: Colors.blue,
            ),
          ),

          // Final Divider
          Divider(thickness: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
