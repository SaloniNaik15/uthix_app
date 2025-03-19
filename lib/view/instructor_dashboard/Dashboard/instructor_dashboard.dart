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

  // Added the Submission card as an additional entry.
  final List<Map<String, String>> dashBoard = [
    {"image": "assets/instructor/create_class.png", "title": "Create Class"},
    {"image": "assets/instructor/my_classes.png", "title": "My Classes"},
    {"image": "assets/instructor/calender.png", "title": "Calender"},
    {
      "image": "assets/instructor/study_materials.png",
      "title": "Study Material"
    },
    {"image": "assets/instructor/Submission.png", "title": "Submission"},
  ];

  // Controllers for class creation fields
  final TextEditingController _classnameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  final TextEditingController _classlinkController = TextEditingController();

  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/classroom";
  List<Map<String, dynamic>> subjects = [];
  int? selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fetchSubjects();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
  }

  Future<void> _fetchSubjects() async {
    try {
      Response response = await _dio.get(
        "https://admin.uthix.com/api/subject",
        options: Options(
          headers: {
            "Authorization":
                "Bearer 15|px3G0ncBD1lRY4ZkPQSA96JqtQBdgSmmDlOReFFf183ba939"
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data["subjects"] != null) {
          setState(() {
            subjects = List<Map<String, dynamic>>.from(data["subjects"]);
          });
        } else {
          debugPrint("Subjects key is missing in the response: $data");
        }
      } else {
        debugPrint(
            "Failed to fetch subjects: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching subjects: $e");
    }
  }

  Future<void> _createClass() async {
    if (selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a subject!")));
      return;
    }
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in. Please log in.")));
      return;
    }

    final requestData = {
      "instructor_id": 2,
      "class_name": _classnameController.text.trim(),
      "section": _sectionController.text.trim(),
      "subject_id": selectedSubjectId,
      "link": _classlinkController.text.trim(),
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
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Class Name (required)", _classnameController,
                  "eg., Class V"),
              _buildTextField("Section", _sectionController, "eg., Section B"),
              _buildDropdownField("Subject", subjects, selectedSubjectId),
              _buildTextField("Class Link", _classlinkController,
                  "eg., www.zoom73452670.com"),
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
                        style: GoogleFonts.inter(
                          fontSize: 16,
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
          padding: const EdgeInsets.only(left: 35),
          child: Row(
            children: [
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
                  child: Image.asset("assets/login/profile.jpeg",
                      fit: BoxFit.cover),
                ),
              ),
               SizedBox(width: 20.w),
              Text(
                "Hii Surnamika",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Build the dashboard grid.
  Widget _buildDashboardGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
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
                case "Submission":
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Submission()));
                  break;
              }
            },
            child: Container(
              height: 162,
              width: 162,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // For the "Submission" card, set a fixed image height.
                  item["title"] == "Submission"
                      ? Image.asset(
                          item["image"]!,
                          height: 100,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(item["image"]!),
                  Text(
                    item["title"]!,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
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
    );
  }

  // Build the bottom navigation bar.

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
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(95, 95, 95, 1),
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false, // ✅ Removes back arrow
            elevation: 0,
          ),
          body: Stack(
            children: [
              /// Background Image Covering Full Screen
              Positioned.fill(
                top: 100,
                child: Image.asset(
                  "assets/instructor/background.png",
                  fit: BoxFit.cover,
                ),
              ),
      
              /// Scrollable Dashboard Content
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: _buildDashboardGrid(),
                    ),
                  ),
                ],
              ),
      
              /// Fixed Bottom Navigation Bar
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
          )),
    );
  }

  // Reusable text field builder.
  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Container(
          height: 45,
          width: 341,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Reusable dropdown builder.
  Widget _buildDropdownField(
      String label, List<Map<String, dynamic>> items, int? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black54),
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
            hint: Text("Select Subject",
                style:
                    GoogleFonts.urbanist(fontSize: 14, color: Colors.black45)),
            items: items.map((subject) {
              return DropdownMenuItem<int>(
                value: subject["id"],
                child: Text(subject["name"],
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: Colors.black87)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubjectId = value;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
