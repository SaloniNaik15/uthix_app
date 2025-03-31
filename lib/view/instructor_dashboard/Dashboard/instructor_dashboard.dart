import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_items.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';
import 'package:uthix_app/view/instructor_dashboard/calender/calender.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';
import '../Profile/detail_profile.dart';
import 'ClassData.dart';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({Key? key}) : super(key: key);

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  int selectedIndex = 0;
  String? token;
  String instructorName = 'No Name';
  String? instructorImageUrl;

  // List of classroom objects fetched from API.
  List<Map<String, dynamic>> classroomsFromApi = [];
  // Selected classroom id.
  int? selectedClassId;

  // For subjects.
  List<Map<String, dynamic>> subjects = [];
  int? selectedSubjectId;

  // Updated API URL for posting classroom data.
  final String apiUrl = "https://admin.uthix.com/api/instructor-classroom";
  final Dio _dio = Dio();

  Future<void> loadProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('instructor_name') ?? 'No Name';
    final imageUrl = prefs.getString('instructor_image_url');
    setState(() {
      instructorName = name;
      instructorImageUrl = imageUrl;
    });
  }

  // Fetch classrooms using token.
  Future<void> _fetchClasses() async {
    try {
      Response response = await _dio.get(
        "https://admin.uthix.com/api/all-classroom",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data["classrooms"] != null) {
          List classrooms = data["classrooms"];
          setState(() {
            // Save the full classroom objects so we can use their id.
            classroomsFromApi = List<Map<String, dynamic>>.from(classrooms);
          });
        } else {
          debugPrint("Key 'classrooms' not found in response: $data");
        }
      } else {
        debugPrint(
            "Failed to fetch classrooms: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching classrooms: $e");
    }
  }

  // Fetch subjects for the instructor.
  Future<void> _fetchSubjects() async {
    try {
      Response response = await _dio.get(
        "https://admin.uthix.com/api/instructor-get-subject",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data["subject"] != null) {
          setState(() {
            subjects = List<Map<String, dynamic>>.from(data["subject"]);
          });
        } else {
          debugPrint("Subjects key is missing in the response: $data");
        }
      } else {
        debugPrint(
            "Failed to fetch subject: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching subject: $e");
    }
  }

  // Load token and fetch both subjects and classrooms.
  Future<void> _loadTokenAndSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    setState(() {
      token = storedToken;
    });
    if (storedToken != null) {
      await _fetchSubjects();
      await _fetchClasses();
    }
  }

  // Create a new classroom by posting classroom_id and subject_id.
  Future<void> _createClass() async {
    if (selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a subject!")));
      return;
    }
    if (selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a class!")));
      return;
    }
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in. Please log in.")));
      return;
    }

    final requestData = {
      "classroom_id": selectedClassId,
      "subject_id": selectedSubjectId,
    };

    try {
      Response response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
        data: requestData,
      );
      final responseData = response.data;
      if (response.statusCode == 201 && responseData["status"] == true) {
        // Extract the classroom details from the response.
        final classroom = responseData["classroom"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("classroom_id", classroom["classroom_id"].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseData["message"])));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassData()),
        );
      } else {
        debugPrint("Failed: ${responseData["errors"]}");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio Error Code: ${e.response?.statusCode}");
        debugPrint("Error Data: ${e.response?.data}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.response?.data}")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unexpected Error: ${e.toString()}")));
      }
    }
  }

  // Navigation callback for bottom navbar.
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 0;
        });
      });
    }
  }

  // Displays a modal dialog for classroom creation.
  void showCreateClassModal() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Create Class",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Center(child: _buildModalContent()),
          ),
        );
      },
    );
  }

  // Build the modal dialog content.
  Widget _buildModalContent() {
    return Material(
      borderRadius: BorderRadius.circular(23),
      child: Container(
        width: 375,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Class and Invite Participants",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown for Classroom selection fetched from API.
              _buildClassDropdown(),
              // Dropdown for Subject selection.
              _buildDropdownField("Subject", subjects, selectedSubjectId),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _createClass,
                  child: Container(
                    width: 150,
                    height: 37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromRGBO(43, 92, 116, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Build the dropdown for Classroom using API data.
  Widget _buildClassDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Class",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
          ),
          child: DropdownButtonFormField<int>(
            // onTap callback to refresh classroom data.
            onTap: () {
              _fetchClasses();
            },
            items: classroomsFromApi.map((classroom) {
              return DropdownMenuItem<int>(
                value: classroom["id"],
                child: Text(
                  classroom["class_name"],
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                ),
              );
            }).toList(),
            value: selectedClassId,
            isExpanded: true,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: Text(
              "Select Class",
              style: TextStyle(fontSize: 12.sp, color: Colors.black45),
            ),
            onChanged: (int? val) {
              setState(() {
                selectedClassId = val;
              });
            },
            dropdownColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Build the reusable dropdown for Subject selection.
  Widget _buildDropdownField(String label, List<Map<String, dynamic>> items, int? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
          ),
          child: DropdownButton<int>(
            value: selectedValue,
            isExpanded: true,
            dropdownColor: Colors.white,
            hint: Text("Select Subject", style: TextStyle(fontSize: 12.sp, color: Colors.black45)),
            items: items.map((subject) {
              return DropdownMenuItem<int>(
                value: subject["id"],
                child: Text(subject["name"], style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubjectId = value;
              });
            },
          ),
        ),
      ],
    );
  }

  // Build the header section.
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: const Color.fromRGBO(232, 232, 232, 1),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(right: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Hi $instructorName",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              SizedBox(width: 18.w),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailProfile()),
                    );
                  },
                  child: ClipOval(
                      child: instructorImageUrl != null
                          ? Image.network(instructorImageUrl!, fit: BoxFit.cover)
                          : Image.asset("assets/icons/profile.png", fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  // Build the dashboard grid.
  Widget _buildDashboardGrid() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          shrinkWrap: true,
          itemCount: dashBoard.length,
          itemBuilder: (context, index) {
            final item = dashBoard[index];
            return GestureDetector(
              onTap: () {
                switch (item["title"]) {
                  case "Create Class":
                    showCreateClassModal();
                    break;
                  case "My Classes":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassData()),
                    );
                    break;
                  case "Calender":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Calender()),
                    );
                    break;
                  case "Study Material":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Files()),
                    );
                    break;
                }
              },
              child: Container(
                height: 162.h,
                width: 162.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(item["image"]!, fit: BoxFit.contain),
                    Text(
                      item["title"]!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Dashboard items.
  final List<Map<String, String>> dashBoard = [
    {"image": "assets/instructor/create_class.png", "title": "Create Class"},
    {"image": "assets/instructor/my_classes.png", "title": "My Classes"},
    {"image": "assets/instructor/calender.png", "title": "Calender"},
    {"image": "assets/instructor/study_materials.png", "title": "Study Material"},
  ];

  @override
  void initState() {
    super.initState();
    _loadTokenAndSubjects();
    loadProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 30.h,
          backgroundColor: Colors.white,
          title: Text(
            "Instructor Dashboard",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(95, 95, 95, 1),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Background Image Covering Full Screen.
            Positioned.fill(
              top: 100,
              child: Image.asset(
                "assets/instructor/background.png",
                fit: BoxFit.cover,
              ),
            ),
            // Scrollable Dashboard Content.
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildDashboardGrid(),
                  ),
                ),
              ],
            ),
            // Fixed Bottom Navigation Bar.
            Positioned(
              bottom: 15.h,
              left: 0,
              right: 0,
              child: Center(
                child: Navbar(onItemTapped: onItemTapped, selectedIndex: selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
