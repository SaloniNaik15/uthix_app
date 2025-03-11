import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';
import 'package:uthix_app/view/instructor_dashboard/calender/calender.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';

import 'ClassData.dart';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_outlined, "title": "Home", "page": null},
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": Files()},
    {"icon": Icons.chat_outlined, "title": "Chat", "page": const Chat()},
    {
      "icon": Icons.person_outline,
      "title": "Profile",
      "page": const ProfileAccount()
    },
  ];

  final List<Map<String, String>> dashBoard = [
    {"image": "assets/instructor/create_class.png", "title": "Create Class"},
    {"image": "assets/instructor/my_classes.png", "title": "My Classes"},
    {"image": "assets/instructor/calender.png", "title": "Calender"},
    {
      "image": "assets/instructor/study_materials.png",
      "title": "Study Material"
    },
  ];

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

  // Controllers for text input
  final TextEditingController _classnameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _classlinkController = TextEditingController();

  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/classroom";
  final String token = "112|OZqf3MUzqsvrPd0XkqX7tT9YM0mCwlf0E6Az5Nykfb3c42fd";

  List<Map<String, dynamic>> subjects = [];
  int? selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  // Function to create class by posting user-entered data.
  // Note: The payload does not include a "classroom_id" so that the backend generates it automatically.
  Future<void> _createClass() async {
    if (selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a subject!")));
      return;
    }

    // Prepare the request payload using the current controller values.
    final requestData = {
      "instructor_id": 1, // Use integer or string as expected by your API
      "class_name": _classnameController.text.trim(),
      "section": _sectionController.text.trim(),
      "subject_id": selectedSubjectId,
      "link": _classlinkController.text.trim(),
    };

    // Debug print to verify request payload
    print("Request Data: ${jsonEncode(requestData)}");

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
      // Check that the API returns a 201 status code and a true status in the response body.
      if (response.statusCode == 201 && responseData["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassData()),
        );
      } else {
        // Print errors to console for debugging
        print("Failed: ${responseData["errors"]}");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio Error Code: ${e.response?.statusCode}");
        print("Error Data: ${e.response?.data}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.response?.data}")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected Error: ${e.toString()}")));
      }
    }
  }

  // Function to fetch subjects for the dropdown.
  Future<void> _fetchSubjects() async {
    try {
      Response response = await _dio.get(
        "https://admin.uthix.com/api/subject",
        options: Options(headers: {
          "Authorization":
              "Bearer 111|mKDQUpVlndNCwxgRQ8DuI6EjKmF6o09WMh46tcWGf7321fea"
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          subjects = List<Map<String, dynamic>>.from(response.data["subjects"]);
        });
      }
    } catch (e) {
      print("Error fetching subjects: $e");
    }
  }

  // Modal dialog that uses the same controllers so that user-entered data is retained.
  void showCenteredModal() {
    // Optionally refresh the subjects list before showing the modal.
    _fetchSubjects();

    showGeneralDialog(
      context: context,
      barrierLabel: "Create Class",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(23),
                child: Container(
                  width: 375,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
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
                      _buildTextField("Class Name (required)",
                          _classnameController, "eg., Class V"),
                      _buildTextField(
                          "Section", _sectionController, "eg., Section B"),
                      _buildDropdownField(
                          "Subject", subjects, selectedSubjectId),
                      _buildTextField("Class Link", _classlinkController,
                          "eg., www.zoom73452670.com"),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _createClass,
                        child: Center(
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
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header section
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 50, top: 50),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 25),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "Instructor Dashboard",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(95, 95, 95, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: const Color.fromRGBO(232, 232, 232, 1),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
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
                        child: Image.asset(
                          "assets/login/profile.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Hii Surnamika",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
          // Background image positioned below header
          Positioned.fill(
            top: 200,
            child: Image.asset(
              "assets/instructor/background.png",
              fit: BoxFit.cover,
            ),
          ),
          // Dashboard grid
          Positioned.fill(
            top: 250,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  shrinkWrap: true,
                  itemCount: dashBoard.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (dashBoard[index]["title"] == "Create Class") {
                          showCenteredModal();
                        }
                        if (dashBoard[index]["title"] == "My Classes") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassData()),
                          );
                        }
                        if (dashBoard[index]["title"] == "Calender") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Calender()),
                          );
                        }
                        if (dashBoard[index]["title"] == "Study Material") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Files()),
                          );
                        }
                      },
                      child: Container(
                        height: 162,
                        width: 162,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(dashBoard[index]["image"]!),
                            Text(
                              dashBoard[index]["title"]!,
                              style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(96, 95, 95, 1)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Bottom navigation bar
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Navbar(
                  onItemTapped: onItemTapped, selectedIndex: selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
