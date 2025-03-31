import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // For File
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Image picker import
import 'package:image_picker/image_picker.dart';

import '../HomePages/HomePage.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String? accessLoginToken;
  String? userName;
  String? networkImageUrl;
  Map<String, dynamic>? selectedClass;
  List<Map<String, dynamic>> _classOptions = [];
  String? _selectedClass;

  // Controllers for each text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _genderValue; // for dropdown
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();

  // For handling the profile image
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 1) Loads token, 2) Loads cached profile, 3) Fetches profile from API
  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
    await fetchClasses();
    _fetchUserProfile();
    _fetchstudentProfile();
  }

  List<Map<String, dynamic>> classOptions = [];
  bool isLoading = true;

  Future<void> fetchClasses() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $accessLoginToken';

      final response =
          await dio.get('https://admin.uthix.com/api/all-classroom');

      if (response.statusCode == 200 && response.data["status"] == true) {
        List<Map<String, dynamic>> loadedClasses =
            List<Map<String, dynamic>>.from(
          response.data["classrooms"].map((classroom) => {
                "id": classroom["id"].toString(),
                "name": classroom["class_name"]
              }),
        );

        // Match the ID from _classController to select the correct class map
        Map<String, dynamic>? foundClass = loadedClasses.firstWhere(
          (item) => item["id"].toString() == _classController.text,
          orElse: () => {},
        );

        setState(() {
          classOptions = loadedClasses;
          selectedClass = foundClass.isNotEmpty ? foundClass : null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching classes: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "https://admin.uthix.com/api/profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _populateFields(data);

        // Cache the profile data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_profile", jsonEncode(data));
        log("Profile updated from API and cached.");
      } else {
        log("Failed to fetch user profile: ${response.statusMessage}");
      }
    } catch (e) {
      log("Error fetching user profile: $e");
    }
  }

  /// Populates the text controllers with data from the profile map
  void _populateFields(Map<String, dynamic> data) {
    setState(() {
      userName = data["name"];
      _nameController.text = data["name"] ?? "";
      _emailController.text = data["email"] ?? "";
      _phoneController.text = data["phone"]?.toString() ?? "";
      _dobController.text = data["dob"] ?? "";
      _genderValue = data["gender"];
      _classController.text = data["class"] ?? "";
      _streamController.text = data["stream"] ?? "";
    });
  }

  Future<void> _submitProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    final gender = _genderValue;
    final userClass = _classController.text.trim();
    final stream = _streamController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        gender == null ||
        userClass.isEmpty ||
        stream.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    try {
      final dio = Dio();

      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "dob": dob,
        "gender": gender,
        "classroom_id": userClass,
        "stream": stream,
        if (_profileImage != null)
          "image": await MultipartFile.fromFile(
            _profileImage!.path,
            filename: "profile.jpg",
          ),
      });
      log("Saloni:${formData}");

      // Log the data before sending
      log("📤 Posting Profile Data:");
      formData.fields.forEach((field) => log("${field.key}: ${field.value}"));
      if (_profileImage != null) {
        log("📸 Profile Image: ${_profileImage!.path}");
      }

      final response = await dio.post(
        "https://admin.uthix.com/api/student-profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessLoginToken",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Profile submitted successfully.");
        log("🔄 Server Response: ${response.data}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );

        // Cache updated profile
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_profile", jsonEncode(response.data));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePages()),
        );
      } else {
        log("❌ Failed to submit profile: ${response.statusCode}");
        log("Response body: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    } catch (e) {
      log("❌ Error submitting profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred.")),
      );
    }
  }

  Future<void> _fetchstudentProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "https://admin.uthix.com/api/student-profile",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessLoginToken",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final data = response.data["data"];

        if (data != null && data is List && data.isNotEmpty) {
          final profileData = data[0];
          final user = profileData["user"];

          setState(() {
            _phoneController.text = user?["phone"]?.toString() ?? "";
            _dobController.text = user?["dob"] ?? "";
            _genderValue = user?["gender"];
            String? classroomId = profileData["classroom_id"]?.toString();
            if (classroomId != null) {
              _classController.text = classroomId;
            }
            _streamController.text = profileData["stream"] ?? "";

            if (user?["image"] != null && user!["image"].toString().isNotEmpty) {
              networkImageUrl =
              "https://admin.uthix.com/storage/images/student/${user?["image"]}";
            } else {
              networkImageUrl = null;
            }
          });

          if (networkImageUrl != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("student_profile_image_url", networkImageUrl!);
          }

          log("✅ Profile fields loaded successfully.");
        } else {
          log("❌ Profile data is null or empty.");
        }
      } else {
        log("❌ Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Error fetching profile: $e");
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
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Circle Avatar (User Photo)
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (networkImageUrl != null
                              ? NetworkImage(networkImageUrl!)
                              : const AssetImage("assets/icons/profile.png"))
                          as ImageProvider,
                  onBackgroundImageError: (_, __) {
                    setState(() {
                      networkImageUrl = null;
                    });
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage, // Open gallery
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B5C74),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // "Name"
            _buildTextField(
              label: "Name",
              hint: "Enter your name",
              controller: _nameController,
              icon: Icons.person,
            ),

            // "Email"
            _buildTextField(
              label: "Email",
              hint: "Enter your email",
              controller: _emailController,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            // "Phone Number"
            _buildTextField(
              label: "Phone Number",
              hint: "Enter your phone number",
              controller: _phoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            // "Password"
            // _buildTextField(
            //   label: "Password",
            //   hint: "Enter your password",
            //   controller: _passwordController,
            //   icon: Icons.lock,
            //   obscureText: true,
            // ),

            // "Date of Birth"
            _buildDateField(
              label: "Date of Birth",
              hint: "dd-mm-yyyy",
              controller: _dobController,
              icon: Icons.calendar_month,
            ),

            // "Gender" (Dropdown)
            _buildGenderDropdown(),

            // "Class"
            _buildClassDropdown(),

            // "Stream"
            _buildTextField(
              label: "Stream",
              hint: "eg. Maths Computer",
              controller: _streamController,
              icon: Icons.menu_book_outlined,
            ),

            const SizedBox(height: 20),

            // "Submit Profile" Button
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5C74),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: _submitProfile,
                child: const Text(
                  "Submit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Class",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFD2D2D2)),
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedClass,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    hint: const Text("Select Class"),
                    dropdownColor: Colors.white,
                    items: classOptions.map((classItem) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: classItem,
                        child: Text(classItem["name"]),
                      );
                    }).toList(),
                    onChanged: (val) {
                      print("Selected Class: ${val?["name"]}");
                      setState(() {
                        selectedClass = val;
                        _classController.text = val!["id"].toString();
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field label
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          // Actual text field
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field label
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dialogBackgroundColor: Colors.white, // background
                          colorScheme: const ColorScheme.light(
                            primary:
                                Color(0xFF2B5C74), // header & selected date
                            onPrimary: Colors.white, // text on selected date
                            onSurface: Colors.black, // text color on calendar
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Color(0xFF2B5C74), // OK/Cancel color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    final dobString =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    controller.text = dobString;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFD2D2D2)),
            ),
            child: DropdownButtonFormField<String>(
              value: _genderValue,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              hint: const Text("Select Gender"),
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(value: "male", child: Text("Male")),
                DropdownMenuItem(value: "female", child: Text("Female")),
                DropdownMenuItem(value: "other", child: Text("Other")),
              ],
              onChanged: (val) {
                setState(() {
                  _genderValue = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
