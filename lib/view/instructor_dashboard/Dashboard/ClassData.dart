import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool isLoading = true;
  String? token;

  // Cache key for classes.
  final String classesCacheKey = "cached_classes";

  final String apiUrl = "https://admin.uthix.com/api/instructor-classroom";

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load token from SharedPreferences and try to load cached data.
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    debugPrint("Token loaded: $token");

    // Try to load cached classes first.
    _loadCachedData();

    if (token != null) {
      // Fetch classes.
      await fetchClasses();
    } else {
      log("No token found.");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load cached classes from SharedPreferences.
  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedClasses = prefs.getString(classesCacheKey);
    if (cachedClasses != null) {
      try {
        final List<dynamic> decodedClasses = jsonDecode(cachedClasses);
        setState(() {
          classes = decodedClasses;
          isLoading = false;
        });
      } catch (e) {
        log("Error decoding cached classes: $e");
      }
    }
  }

  // Fetch classes using the fetched token.
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
      // The API returns a JSON with "status" and "classrooms".
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          classes = response.data["classrooms"];
          isLoading = false;
        });
        // Cache the classes data.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            classesCacheKey, jsonEncode(response.data["classrooms"]));
      } else {
        log("Error fetching classes: ${response.data["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error fetching classes: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to get the subject name from a classroom item.
  String _getSubjectName(dynamic classroomItem) {
    try {
      final subject = classroomItem["subject"];
      return subject != null ? subject["name"] ?? "N/A" : "N/A";
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
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : classes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/instructor/UnableToLoadData.png",
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You don't have any classes. Create a new class.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classItem = classes[index];
                    // Extract the classroom id from the top-level "id"
                    final classroomId = classItem["id"].toString();
                    // Get class name from the nested "classroom" object.
                    final className = classItem["classroom"] != null
                        ? classItem["classroom"]["class_name"]
                        : "Unknown Class";
                    // Get subject name using the helper function.
                    final subjectName = _getSubjectName(classItem);
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 10, right: 10, bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          // Navigation if needed.
                        },
                        child: Container(
                          width: 290,
                          height: 150,
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
                                // Class name row.
                                Text(
                                  className,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Subject information.
                                Text(
                                  "Subject: $subjectName",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Row of two buttons: Add Chapter and View All Chapters.
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                43, 92, 116, 1),
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
                                        // Navigate to MyClasses page with the specific classroom ID.
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                43, 92, 116, 1),
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
