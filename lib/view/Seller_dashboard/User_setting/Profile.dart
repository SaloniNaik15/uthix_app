import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String apiUrl = "https://admin.uthix.com/api/vendor/profile";
  int? vendorId;
  int? userId;
  bool isLoading = true;
  String? token;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? image;
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    _loadAuthTokenAndFetchData();
  }

  Future<void> _loadAuthTokenAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("auth_token");
    debugPrint("[log] Retrieved Token: $token");

    if (token != null && token!.isNotEmpty) {
      await fetchProfileData();
    } else {
      setState(() => isLoading = false);
      debugPrint("Token is missing.");
    }
  }

  Future<void> fetchProfileData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final user = data['user'];

        setState(() {
          vendorId = data['id'];
          userId = data['user_id'];
          nameController.text = user['name'] ?? "";
          emailController.text = user['email'] ?? "";
          phoneController.text = user['phone']?.toString() ?? "";
          genderController.text = data['gender'] ?? "";
          addressController.text = data['store_address'] ?? "";
          image = user['image'];
          isLoading = false;
        });
      } else {
        debugPrint("API error: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> updateProfileData() async {
    try {
      final dio = Dio();
      FormData formData = FormData.fromMap({
        "id": vendorId,
        "user_id": userId,
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "gender": genderController.text,
        "store_address": addressController.text,
        if (_pickedImageFile != null)
          "image": await MultipartFile.fromFile(
            _pickedImageFile!.path,
            filename: _pickedImageFile!.path.split('/').last,
          ),
      });
      formData.fields.forEach((field) {
        debugPrint("📦 FIELD: ${field.key} = ${field.value}");
      });
      if (_pickedImageFile != null) {
        debugPrint("📸 Image to Upload: ${_pickedImageFile!.path}");
      }

      final response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        await fetchProfileData();
        setState(() {
          _pickedImageFile = null;
        });
      } else {
        debugPrint("Update failed: ${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("[log] ❌ Upload Error Response: ${e.response!.data}");
      }
      debugPrint("❌ Error updating profile: $e");
    }
  }

  Widget buildTextField(String label, IconData icon, TextEditingController controller, {required bool readOnly}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : image != null
                    ? NetworkImage("https://admin.uthix.com/storage/images/user/$image")
                    : const AssetImage("assets/icons/profile.png") as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${nameController.text} (You)",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                buildTextField("Name", Icons.person, nameController, readOnly: false),
                buildTextField("Phone", Icons.phone, phoneController, readOnly: false),
                buildTextField("Email", Icons.email, emailController, readOnly: true),
                buildTextField("Gender", Icons.male, genderController, readOnly: false),
                buildTextField("Store Address", Icons.location_on, addressController, readOnly: false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: updateProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5C74),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
