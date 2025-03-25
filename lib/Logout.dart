import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/login/email_id.dart';

Future<void> logoutUser(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        title: Text("Logout Confirmation"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1B617A), // Background color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Background color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Yes, Logout"),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');
              await prefs.remove('user_role');
//used for testing
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => EmailId()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
