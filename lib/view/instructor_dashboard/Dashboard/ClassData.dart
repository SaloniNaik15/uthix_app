import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dummy pages for navigation; replace with your actual implementations.
import '../Class/newclass.dart';
import 'my_classes.dart';

class ClassData extends StatefulWidget {
  const ClassData({Key? key}) : super(key: key);

  @override
  State<ClassData> createState() => _ClassDataState();
}

class _ClassDataState extends State<ClassData> {
  List<dynamic> classes = [];
  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;
  String? token;
  final String apiUrl = "https://admin.uthix.com/api/classroom";
  final String subjectsApiUrl = "https://admin.uthix.com/api/subject";

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load token from SharedPreferences using key "auth_token"
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    debugPrint("Token loaded: $token");
    if (token != null) {
      // Fetch both classes and subjects concurrently.
      await Future.wait([
        fetchClasses(),
        _fetchSubjects(),
      ]);
    } else {
      log("No token found.");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch classes using the fetched token in the Authorization header.
  Future<void> fetchClasses() async {
    try {
      Response response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          classes = response.data["data"];
          // Do not set isLoading to false here; wait for subjects to load.
        });
      } else {
        log("Error fetching classes: ${response.data["message"]}");
      }
    } catch (e) {
      log("Error fetching classes: $e");
    }
  }

  // Fetch subjects so we can map subject ids to names.
  Future<void> _fetchSubjects() async {
    try {
      Response response = await Dio().get(
        subjectsApiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer 345|nAW96QnsVX0ECAc94qyk4QfVC99uWdzdQr6yN9RQ18129cfa"
          },
        ),
      );
      if (response.statusCode == 200 && response.data["subjects"] != null) {
        setState(() {
          subjects = List<Map<String, dynamic>>.from(response.data["subjects"]);
          isLoading = false; // Mark loading complete once both classes and subjects are fetched.
        });
      } else {
        log("Error fetching subjects: ${response.data["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error fetching subjects: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to get the subject name from the subject id.
  String _getSubjectName(dynamic subjectId) {
    try {
      final subject = subjects.firstWhere(
            (subj) => subj["id"] == subjectId,
        orElse: () => {},
      );
      return subject["name"] ?? "N/A";
    } catch (e) {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          height: 130,
          width: double.infinity,
          color: const Color.fromRGBO(43, 92, 116, 1),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              children: [
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  "Class Room",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/login/profile.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classItem = classes[index];
          // Extract the classroom ID (ensure your API returns an "id" field)
          final classroomId = classItem['id'].toString();
          return Padding(
            padding: const EdgeInsets.only(
                top: 15, left: 20, right: 20, bottom: 15),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Newclass(
                //       classroomId: classroomId,
                //     ),
                //   ),
                // );
              },
              child: Container(
                width: 290,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                  color: const Color.fromRGBO(246, 246, 246, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class name and section row.
                      Row(
                        children: [
                          Text(
                            classItem['class_name'] ?? "Unknown Class",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            classItem['section'] ?? "No section",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Removed the three-dot icon here.
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Subject information (displays subject name by looking it up).
                      Text(
                        "Subject: ${_getSubjectName(classItem['subject_id'])}",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Participant avatars row.
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 23,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 45,
                                  child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          fit: BoxFit.cover,
                                        ),
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
                      // Row of two buttons: Add Chapter and View All Details.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to Add Chapter page with the specific classroom ID.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Newclass(
                                    classroomId: classroomId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 39,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                  const Color.fromRGBO(43, 92, 116, 1),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Add Chapter",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                        43, 92, 116, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to MyClasses page with the specific classroom ID so that the chapters for that classroom are shown.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyClasses(
                                    classroomId: classroomId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 39,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                  const Color.fromRGBO(43, 92, 116, 1),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "View All Chapters",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                        43, 92, 116, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
