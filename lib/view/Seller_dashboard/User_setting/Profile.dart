import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<Profile> {
  final String apiUrl = "https://admin.uthix.com/api/vendor/profile";
  Map<String, dynamic> profileData = {};
  bool isLoading = true;
  String? email;
  String? password;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    if (accessToken != null && accessToken!.isNotEmpty) {
      fetchProfileData();
    } else {
      log("Access token is missing, skipping API call");
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      email = prefs.getString("email") ?? "No Email Found";
      password = prefs.getString("password") ?? "No Password Found";
      accessToken = prefs.getString("userToken") ?? "";
    });

    log("Retrieved Email: $email");
    log("Retrieved Password: $password");
    log("Retrieved Access Token: $accessToken");
  }

  Future<void> fetchProfileData() async {
    if (accessToken == null || accessToken!.isEmpty) {
      log("Cannot fetch profile data: Access token is missing");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (!mounted) return;

      log("API Response Code: ${response.statusCode}");
      log("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profileData = data["data"];
          isLoading = false;
        });
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<void> updateProfile(String field, String value) async {
    log("🛠️ Sending Update Request...");

    final Map<String, dynamic> requestData = {
      "id": profileData["id"],
      "user_id": profileData["user_id"],
      "name": profileData["name"],
      "mobile": profileData["mobile"],
      "gender": profileData["gender"],
      "dob": profileData["dob"],
      "address": profileData["address"],
      "store_name": profileData["store_name"],
      "store_address": profileData["store_address"],
      "logo": profileData["logo"],
      "school": profileData["school"],
      "counter": profileData["counter"],
      "status": profileData["status"],
      "isApproved": profileData["isApproved"],
      "created_at": profileData["created_at"],
      "updated_at": DateTime.now().toIso8601String(),
      field: value, // Field to update
    };

    log("📌 Request Data: ${json.encode(requestData)}");

    try {
      final response = await http.put(
        Uri.parse(""), // Ensure ID is included
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(requestData),
      );

      log("📥 Response Status Code: ${response.statusCode}");
      log("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        log("✅ Profile Updated Successfully: $field -> $value");

        // Refresh profile data after update
        await fetchProfileData();
      } else {
        log("⚠️ Profile update failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("❌ Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "Urbanist",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Seller_dashboard_images/ManageStoreBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ColoredBox(
                        color: Color(0xFF2B5C74),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage:
                                        AssetImage("assets/icons/profile.png")),
                              ),
                            ),
                            Positioned(
                              bottom: -1,
                              right: -1,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profileData["name"] ?? "User",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          ProfileField(
                            icon: Icons.email,
                            label: "Email",
                            hint: "Enter your email",
                            initialValue: email ?? "",
                            onSave: (value) => updateProfile("email", value),
                          ),
                          ProfileField(
                            icon: Icons.lock,
                            label: "Password",
                            hint: "Enter your password",
                            initialValue: password ?? "",
                            isPassword: true,
                            onSave: (value) => updateProfile("password", value),
                          ),
                          ProfileField(
                            icon: Icons.person,
                            label: "Name",
                            hint: "Enter your name",
                            initialValue: profileData["name"] ?? "",
                            onSave: (value) => updateProfile("name", value),
                          ),
                          ProfileField(
                            icon: Icons.phone,
                            label: "Phone",
                            hint: "Enter your phone number",
                            initialValue: profileData["mobile"] ?? "",
                            onSave: (value) => updateProfile("mobile", value),
                          ),
                          ProfileField(
                            icon: Icons.male,
                            label: "Gender",
                            hint: "Select your gender",
                            initialValue: profileData["gender"] ?? "",
                            onSave: (value) => updateProfile("gender", value),
                          ),
                          ProfileField(
                            icon: Icons.location_on,
                            label: "Current Address",
                            hint: "Enter your current address",
                            initialValue: profileData["address"] ?? "",
                            onSave: (value) => updateProfile("address", value),
                          ),
                          ProfileField(
                            icon: Icons.school,
                            label: "University",
                            hint: "Enter your university",
                            initialValue: profileData["school"] ?? "",
                            onSave: (value) => updateProfile("school", value),
                          ),
                          ProfileField(
                            icon: Icons.location_on,
                            label: "Permanent Address",
                            hint: "Enter your permanent address",
                            initialValue: profileData["store_address"] ?? "",
                            onSave: (value) =>
                                updateProfile("store_address", value),
                          ),
                          ProfileField(
                            icon: Icons.school,
                            label: "Student ID",
                            hint: "Enter your student ID",
                            initialValue: profileData["user_id"].toString(),
                            onSave: (value) => updateProfile("user_id", value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final String? initialValue;
  final bool isPassword;
  final Function(String) onSave; // Callback for saving changes

  ProfileField({
    required this.icon,
    required this.label,
    required this.hint,
    this.initialValue,
    this.isPassword = false,
    required this.onSave,
  });

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  late TextEditingController controller;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  Future<void> saveChanges() async {
    String updatedValue = controller.text;
    if (updatedValue.isNotEmpty) {
      await widget.onSave(updatedValue); // Call the API function

      log("Updated Field: ${widget.label}"); // Log the field name
      log("Updated Value: $updatedValue"); // Log the new value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        decoration: BoxDecoration(
          color: Color(0xFFFCFCFC),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Color(0xFFD2D2D2)),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.black54),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: widget.isPassword,
                decoration: InputDecoration(border: InputBorder.none),
                enabled: isEditing,
                onFieldSubmitted: (_) => saveChanges(), // Save on enter key
              ),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit,
                  color: Colors.black54),
              onPressed: () {
                if (isEditing) {
                  saveChanges();
                }
                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
