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

  Future<void> loadProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('instructor_name') ?? 'No Name';
    final imageUrl = prefs.getString('instructor_image_url');

    setState(() {
      instructorName = name;
      instructorImageUrl = imageUrl;
    });
  }

  final List<Map<String, String>> dashBoard = [
    {"image": "assets/instructor/create_class.png", "title": "Create Class"},
    {"image": "assets/instructor/my_classes.png", "title": "My Classes"},
    {"image": "assets/instructor/calender.png", "title": "Calender"},
    {"image": "assets/instructor/study_materials.png", "title": "Study Material"},

  ];

  // New dropdown options for class and section.
  final List<String> classOptions = [
    "Class 5th",
    "Class 6th",
    "Class 7th",
    "Class 8th",
    "Class 9th",
    "Class 10th",
    "Class 11th",
    "Class 12th"
  ];
  final List<String> sectionOptions = [
    "Section A",
    "Section B",
    "Section C",
    "Section D"
  ];
  // Selected values for dropdowns.
  String? selectedClass;
  String? selectedSection;


  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/classroom";
  List<Map<String, dynamic>> subjects = [];
  int? selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _loadTokenAndSubjects();
    loadProfileInfo();
  }

  Future<void> _loadTokenAndSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    setState(() {
      token = storedToken;
    });

    if (storedToken != null) {
      await _fetchSubjects();
    }
  }

  Future<void> _fetchSubjects() async {
    try {
      Response response = await _dio.get(
        "https://admin.uthix.com/api/instructor-get-subject",
        options: Options(
          headers: {
            "Authorization":
            "Bearer $token"
          },
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

  Future<void> _createClass() async {
    if (selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a subject!")));
      return;
    }
    if (selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a class!")));
      return;
    }
    if (selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a section!")));
      return;
    }
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in. Please log in.")));
      return;
    }

    final requestData = {

      "class_name": selectedClass,
      "section": selectedSection,
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
        // Extract the classroom id from the response.
        final classroomId = responseData["data"]["id"];

        // Store the classroom id in SharedPreferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("classroom_id", classroomId.toString());

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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.response?.data}")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected Error: ${e.toString()}")));
      }
    }
  }

  // Navigation callback
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

  // Displays a modal dialog for class creation.
  void showCreateClassModal() {
    _fetchSubjects();
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
              // Dropdown for Class selection (Class 5th to Class 12th)
              _buildStringDropdownField("Class", classOptions, selectedClass,
                      (val) {
                    setState(() {
                      selectedClass = val;
                    });
                  }),
              // Dropdown for Section selection (Section A to Section D)
              _buildStringDropdownField("Section", sectionOptions, selectedSection,
                      (val) {
                    setState(() {
                      selectedSection = val;
                    });
                  }),
              // Existing subject dropdown remains unchanged
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
          padding:  EdgeInsets.only(right: 30.w),
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
                child: ClipOval(
                  child: instructorImageUrl != null
                      ? Image.network(instructorImageUrl!, fit: BoxFit.cover)
                      : Image.asset("assets/icons/profile.png", fit: BoxFit.cover)
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClassData()));
                    break;
                  case "Calender":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Calender()));
                    break;
                  case "Study Material":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Files()));
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


  // Reusable dropdown builder for integer values (for Subject).
  Widget _buildDropdownField(
      String label, List<Map<String, dynamic>> items, int? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.w700, color: Colors.black54),
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
            hint: Text("Select Subject",
                style:
                TextStyle(fontSize: 12.sp, color: Colors.black45)),
            items: items.map((subject) {
              return DropdownMenuItem<int>(
                value: subject["id"],
                child: Text(subject["name"],
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.black87)),
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

  // Reusable dropdown builder for String values.
  Widget _buildStringDropdownField(String label, List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            dropdownColor: Colors.white,
            hint: Text("Select $label",
                style: TextStyle(fontSize: 12.sp, color: Colors.black45)),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style:
                    TextStyle(fontSize: 12.sp, color: Colors.black87)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
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
            // Background Image Covering Full Screen
            Positioned.fill(
              top: 100,
              child: Image.asset(
                "assets/instructor/background.png",
                fit: BoxFit.cover,
              ),
            ),
            // Scrollable Dashboard Content
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
            // Fixed Bottom Navigation Bar
            Positioned(
              bottom: 15.h,
              left: 0,
              right: 0,
              child: Center(
                child: Navbar(
                    onItemTapped: onItemTapped, selectedIndex: selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
