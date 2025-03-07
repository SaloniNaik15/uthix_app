// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/LMS/classes.dart';

class YourClasroom extends StatefulWidget {
  const YourClasroom({super.key});

  @override
  State<YourClasroom> createState() => _YourClasroomState();
}

class _YourClasroomState extends State<YourClasroom> {
  int selectedIndex = 0;

  String? email;
  String? password;
  String? accessLoginToken;
  int? studentId;
  bool isLoading = true; // For loading indicator
  bool hasError = false; // Error state

  List<Map<String, String>> classList = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchAndLogClassroomData();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
    await createStudent();
  }

  // ✅ Fetch student_id using the token
  Future<int?> createStudent() async {
    if (accessLoginToken == null || accessLoginToken!.isEmpty) {
      log("Error: Token is missing, skipping student creation.");
      return null;
    }

    final response = await http.post(
      Uri.parse("https://admin.uthix.com/api/student"),
      headers: {
        'Authorization': 'Bearer $accessLoginToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    log("Create Student API Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      if (data["data"] != null && data["data"]["user_id"] != null) {
        int newStudentId = data["data"]["user_id"];
        log("✅ New student created with user_id: $newStudentId");
        return newStudentId; // Return the user_id
      } else {
        log("❌ Error: user_id is missing in response.");
        return null;
      }
    } else {
      log("❌ Failed to create student: ${response.statusCode}");
      return null;
    }
  }

  Future<void> fetchAndLogClassroomData() async {
    const url = 'https://admin.uthix.com/api/student-classroom';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Response Body:\n${response.body}\n"); // Log full response

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData["status"] == true && jsonData["students"] != null) {
          List<dynamic> students = jsonData["students"];

          if (students.isEmpty) {
            setState(() {
              classList = []; // No students found
              isLoading = false;
            });
            return;
          }

          List<Map<String, String>> classrooms = [];

          for (var student in students) {
            final classroom = student["classroom"] ?? {};
            final instructor = classroom["instructor"]?["user"] ?? {};

            String className = classroom["class_name"] ?? "Default Class";
            String section = classroom["section"] ?? "Default Section";
            String instructorName = instructor["name"] ?? "Unknown Instructor";

            log("Class Name: $className");
            log("Section: $section");
            log("Instructor Name: $instructorName");
            print("---------------------------");

            if (classroom.isNotEmpty) {
              classrooms.add({
                "className": className,
                "section": section,
                "instructor": instructorName,
              });
            }
          }

          setState(() {
            classList = classrooms;
            isLoading = false;
          });
        } else {
          setState(() {
            classList = [];
            isLoading = false;
          });
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  List<dynamic> classrooms = [];
  Future<void> fetchClassrooms() async {
    try {
      final response = await http.get(
        Uri.parse('https://admin.uthix.com/api/all-classroom'),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Log API Response

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          classrooms = data['classrooms'];
        });
      } else if (response.statusCode == 401) {
        print("Unauthorized: Invalid or expired token.");
      } else {
        print("Failed to load classrooms. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching classrooms: $e");
    }
  }

  String? selectedClassroomId; // Stores the selected classroom ID

  Future<void> postSelectedClassroom(String classroomId) async {
// Replace with your actual token

    try {
      final response = await http.post(
        Uri.parse('https://admin.uthix.com/api/student-classroom'),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "classroom_id": classroomId,
        }),
      );

      print("POST Status Code: ${response.statusCode}");
      print("POST Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Classroom selected successfully!");
      } else {
        print(
            "Failed to select classroom. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error posting selected classroom: $e");
    }
  }

  void showClassDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Class Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    classrooms.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: classrooms.length,
                              itemBuilder: (context, index) {
                                final classroom = classrooms[index];
                                bool isSelected = selectedClassroomId ==
                                    classroom['id'].toString();

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedClassroomId = classroom['id']
                                          .toString(); // Store selected ID
                                    });
                                    print(
                                        "Selected Classroom ID: $selectedClassroomId");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.shade100
                                          : Color.fromRGBO(246, 246, 246, 1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Class Name: ${classroom['class_name']}"),
                                        SizedBox(height: 5),
                                        Text(
                                            "Section: ${classroom['section']}"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("No classrooms available."),
                          ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedClassroomId != null) {
                          await postSelectedClassroom(selectedClassroomId!);
                          await fetchAndLogClassroomData();
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_outlined, "title": "Home", "page": HomePages()},
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": null},
    {"icon": Icons.chat_outlined, "title": "Chat", "page": null},
    {"icon": Icons.find_in_page, "title": "Find", "page": BuyTextBooks()},
    {"icon": Icons.person_outline, "title": "Profile", "page": null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 28),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
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
                          ],
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back_ios, size: 25),
                        ),
                      ),
                    ),
                    const SizedBox(width: 75),
                    Text(
                      "Your Clasroom",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/Student_Home_icons/stud_logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(thickness: 1, color: Color.fromRGBO(217, 217, 217, 1)),
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader while fetching
                    : hasError
                        ? Center(
                            child: Text("Failed to load data")) // Error message
                        : classList.isEmpty
                            ? Center(
                                child: Text(
                                    "No classrooms assigned yet")) // No data
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: classList
                                    .length, // Use the actual list length
                                itemBuilder: (context, index) {
                                  final classData = classList[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        int classroomId =
                                            int.parse(classData["id"]!);
                                        log("SALONI:$classroomId");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Classes(
                                                classroomId:
                                                    classroomId), // Replace with your screen
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 121,
                                        width: 339,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(246, 246, 246, 1),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                217, 217, 217, 1),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    classData["className"] ??
                                                        "Unknown Class",
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromRGBO(
                                                          96, 95, 95, 1),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Icon(Icons.more_vert,
                                                      color: Color.fromRGBO(
                                                          96, 95, 95, 1)),
                                                ],
                                              ),
                                              Text(
                                                "Section: ${classData["section"] ?? 'N/A'}",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      96, 95, 95, 1),
                                                ),
                                              ),
                                              const SizedBox(height: 19),
                                              Text(
                                                "Instructor: ${classData["instructor"] ?? 'N/A'}",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      96, 95, 95, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: NavbarStudent(
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
            ),
          ),
          Positioned(
            bottom: 100, // Adjust to position FAB above Navbar
            right: 20, // Adjust for proper alignment
            child: FloatingActionButton(
              onPressed: () async {
                await fetchClassrooms();
                showClassDetailsDialog(); // Show dialog after fetching data
              },
              backgroundColor:
                  Color.fromRGBO(43, 92, 116, 1), // Custom FAB color
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.white), // White add icon
            ),
          ),
        ],
      ),
      // Bottom right position
    );
  }
}
