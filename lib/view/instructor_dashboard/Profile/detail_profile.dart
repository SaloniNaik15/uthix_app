import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Dashboard/instructor_dashboard.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({Key? key}) : super(key: key);

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  String? accessLoginToken;
  File? _selectedImage;
  String? profileImageUrl;

  // Controllers
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'bio': TextEditingController(),
    'gender': TextEditingController(),
    'qualification': TextEditingController(),
    'experience': TextEditingController(),
    'specialization': TextEditingController(),
  };

  // Editable states
  final Map<String, bool> editable = {
    'name': false,
    'phone': false,
    'email': false,
    'bio': false,
    'gender': false,
    'qualification': false,
    'experience': false,
    'specialization': false,
  };

  final Map<String, String> fieldHints = {
    'name': 'Your name',
    'phone': 'Phone Number',
    'email': 'Email',
    'bio': 'Bio',
    'gender': 'Gender',
    'qualification': 'Qualification',
    'experience': 'Experience in years',
    'specialization': 'Specialization',
  };

  final Map<String, IconData> fieldIcons = {
    'name': Icons.person,
    'phone': Icons.phone,
    'email': Icons.email,
    'bio': Icons.info,
    'gender': Icons.female,
    'qualification': Icons.school,
    'experience': Icons.school,
    'specialization': Icons.school,
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    if (token != null && token.isNotEmpty) {
      setState(() {
        accessLoginToken = token;
      });
      await fetchProfile();
    } else {
      debugPrint("❌ No token found in SharedPreferences");
      // Optionally redirect to login or show a message
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "https://admin.uthix.com/api/instructor-profile",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessLoginToken",
          },
        ),
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        final user = response.data['data'][0];
        final userInfo = user['user'];

        setState(() {
          controllers['name']?.text = userInfo['name'] ?? '';
          controllers['phone']?.text = userInfo['phone']?.toString() ?? '';
          controllers['email']?.text = userInfo['email'] ?? '';
          controllers['gender']?.text = userInfo['gender'] ?? '';
          controllers['bio']?.text = user['bio'] ?? '';
          controllers['qualification']?.text = user['qualification'] ?? '';
          controllers['experience']?.text = user['experience']?.toString() ?? '';
          controllers['specialization']?.text = user['specialization'] ?? '';
          final profileImageName =
              user["profile_image"] ?? userInfo["image"]; // fallback
          if (profileImageName != null &&
              profileImageName.toString().toLowerCase() != "null" &&
              profileImageName.toString().isNotEmpty) {
            setState(() {
              profileImageUrl =
                  "https://admin.uthix.com/storage/images/instructor/${userInfo["image"]}";
              log("Profile Image URL: $profileImageUrl");
            });
          }else {
            setState(() {
              profileImageUrl = null; // fallback to default image
            });
          }
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('instructor_name', userInfo['name'] ?? '');
        await prefs.setString('instructor_phone', userInfo['phone']?.toString() ?? '');
        await prefs.setString('instructor_email', userInfo['email'] ?? '');
        await prefs.setString('instructor_specialization', user['specialization'] ?? '');
        await prefs.setString('instructor_experience', user['experience']?.toString() ?? '');
        final imageName = user["profile_image"] ?? userInfo["image"];
        if (imageName != null && imageName.toString().toLowerCase() != "null") {
          await prefs.setString('instructor_image_url',
              "https://admin.uthix.com/storage/images/instructor/$imageName");
        } else {
          await prefs.remove('instructor_image_url');
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }

  }

  Future<void> updateProfile() async {
    if (accessLoginToken == null || accessLoginToken!.isEmpty) {
      debugPrint("❌ No token, cannot update profile.");
      return;
    }

    try {
      // Step 1: Start with base map
      final Map<String, dynamic> formMap = {
        "name": controllers['name']?.text?.trim(),
        "phone": controllers['phone']?.text?.trim(),
        "email": controllers['email']?.text?.trim(),
        "gender": controllers['gender']?.text?.trim(),
        "bio": controllers['bio']?.text?.trim(),
        "qualification": controllers['qualification']?.text?.trim(),
      };

      // Step 2: Conditionally add experience
      final experienceText = controllers['experience']?.text?.trim();
      if (experienceText != null && experienceText.isNotEmpty) {
        final parsedExperience = int.tryParse(experienceText);
        if (parsedExperience != null) {
          formMap["experience"] = parsedExperience;
        }
      }

      // Step 3: Conditionally add specialization
      final specialization = controllers['specialization']?.text?.trim();
      if (specialization != null && specialization.isNotEmpty) {
        formMap["specialization"] = specialization;
      }

      // Step 4: Add profile image if selected
      if (_selectedImage != null) {
        formMap["image"] = await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: "profile.jpg",
        );
      }

      final formData = FormData.fromMap(formMap);
      log("✅ Sending body: $formMap");

      final dioInstance = Dio();
      final response = await dioInstance.post(
        "https://admin.uthix.com/api/instructor-profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessLoginToken",
            "Accept": "application/json",
          },
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile submitted!")),
        );
        setState(() {
          editable.updateAll((key, value) => false);
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstructorDashboard()), // 👈 Your Dashboard screen
        );
      } else {
        debugPrint("❌ Failed to update: ${response.data}");
      }
    } catch (e) {
      debugPrint("❌ Error submitting profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined,
              color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/Seller_dashboard_images/ManageStoreBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            /// Profile Image Section
            Stack(
              children: [
                ColoredBox(
                  color: const Color(0xFF2B5C74),
                  child: SizedBox(
                      height: 40.h, width: MediaQuery.of(context).size.width),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40.r,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (profileImageUrl != null
                                      ? NetworkImage(profileImageUrl!)
                                      : const AssetImage(
                                          "assets/icons/profile.png"))
                                  as ImageProvider,
                          backgroundColor: Colors.grey.shade200,
                          onBackgroundImageError: (_, __) {
                            setState(() {
                              profileImageUrl = null;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: -1.h,
                        right: -1.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18.r,
                          child: Icon(Icons.camera_alt,
                              color: Colors.blue, size: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Text("(You)",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),

            /// Profile Fields
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: ListView(
                  children: controllers.keys.map((key) {
                    return buildProfileField(
                      icon: fieldIcons[key]!,
                      hint: fieldHints[key]!,
                      controller: controllers[key]!,
                      fieldKey: key,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B5C74),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
            minimumSize: Size(double.infinity, 45.h),
          ),
          onPressed: updateProfile,
          child: Text(
            "Submit Profile",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required String fieldKey,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: const Color(0xFFD2D2D2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: editable[fieldKey] ?? false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  isDense: true,
                ),
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, size: 20.sp, color: Colors.black),
              onPressed: () {
                setState(() {
                  editable[fieldKey] = !(editable[fieldKey] ?? false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
