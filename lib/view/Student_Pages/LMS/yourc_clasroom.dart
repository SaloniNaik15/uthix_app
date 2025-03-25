// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/LMS/classes.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';

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

  List<Map<String, dynamic>> classList = [];

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
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
    await createStudent();
  }

  final Dio dio = Dio();

  Future<int?> createStudent() async {
    if (accessLoginToken == null || accessLoginToken!.isEmpty) {
      log("Error: Token is missing, skipping student creation.");
      return null;
    }

    try {
      final response = await dio.post(
        "https://admin.uthix.com/api/student",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("Create Student API Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        if (data["data"] != null && data["data"]["user_id"] != null) {
          int newStudentId = data["data"]["user_id"];
          log("✅ New student created with user_id: $newStudentId");
          return newStudentId;
        } else {
          log("❌ Error: user_id is missing in response.");
        }
      }
    } catch (e) {
      log("❌ Failed to create student: $e");
    }
    return null;
  }

  Future<void> fetchAndLogClassroomData() async {
    const url = 'https://admin.uthix.com/api/student-classroom';
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("STUDNET-Response Body:\n${response.data}\n");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data;

        if (jsonData["status"] == true && jsonData["students"] != null) {
          List<dynamic> students = jsonData["students"];

          if (students.isEmpty) {
            setState(() {
              classList = [];
              isLoading = false;
            });
            return;
          }

          List<Map<String, dynamic>> classrooms = [];
          for (var student in students) {
            final classroom = student["classroom"] ?? {};
            final instructor = classroom["instructor"]?["user"] ?? {};

            int? classroomId = classroom["id"];
            String className = classroom["class_name"] ?? "Default Class";
            String section = classroom["section"] ?? "Default Section";
            String instructorName = instructor["name"] ?? "Unknown Instructor";

            log("Classroom ID: $classroomId");
            log("Class Name: $className");
            log("Section: $section");
            log("Instructor Name: $instructorName");
            print("---------------------------");

            if (classroom.isNotEmpty && classroomId != null) {
              classrooms.add({
                "classroomId": classroomId,
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
      }
    } catch (e) {
      log("WHY:Error: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  List<dynamic> classrooms = [];
  Future<void> fetchClassrooms() async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/all-classroom',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("Response Status Code: ${response.statusCode}");
      log("ALLCLASROMS-Response Body: ${response.data}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
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

  String? selectedClassroomId;
  Future<void> postSelectedClassroom(String classroomId) async {
    try {
      final response = await dio.post(
        'https://admin.uthix.com/api/student-classroom',
        data: jsonEncode({
          "classroom_id": classroomId,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("SELECTION Status Code: ${response.statusCode}");
      log("SELECTION Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Classroom selected successfully!");
      } else {
        log("Failed to select classroom. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error posting selected classroom: $e");
    }
  }

  void showClassDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
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
                        ? Flexible(
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
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Adjust height as needed
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0, // Ensures elements are properly aligned
          leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.arrow_back_ios_outlined))),
          title: Text(
            "Your Classroom",
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
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
            ),
          ],
        ),
      ),

      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Divider(thickness: 1, color: Color.fromRGBO(217, 217, 217, 1)),
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader while fetchin
                    : classList.isEmpty
                        ? Center(
                            child:
                                Text("No classrooms assigned yet")) // No data
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount:
                                classList.length, // Use the actual list length
                            itemBuilder: (context, index) {
                              final classData = classList[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    int classroomId = classData["classroomId"];

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
                                      color: Color.fromRGBO(246, 246, 246, 1),
                                      border: Border.all(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
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
                                                  fontWeight: FontWeight.w600,
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
                                              color:
                                                  Color.fromRGBO(96, 95, 95, 1),
                                            ),
                                          ),
                                          const SizedBox(height: 19),
                                          Text(
                                            "Instructor: ${classData["instructor"] ?? 'N/A'}",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromRGBO(96, 95, 95, 1),
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
            bottom: 120, // Adjust to position FAB above Navbar
            right: 30, // Adjust for proper alignment
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
