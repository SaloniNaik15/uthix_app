import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Class/newclass.dart';
import 'my_classes.dart';

// Placeholder page for Add Chapter
class AddChapterPage extends StatelessWidget {
  const AddChapterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Chapter")),
      body: const Center(child: Text("Add Chapter Page")),
    );
  }
}

// Placeholder page for View All Details
class AllDetailsPage extends StatelessWidget {
  const AllDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Details")),
      body: const Center(child: Text("All Details Page")),
    );
  }
}

class ClassData extends StatefulWidget {
  const ClassData({Key? key}) : super(key: key);

  @override
  State<ClassData> createState() => _ClassDataState();
}

class _ClassDataState extends State<ClassData> {
  List<dynamic> classes = [];
  bool isLoading = true;

  final String token =
      "112|OZqf3MUzqsvrPd0XkqX7tT9YM0mCwlf0E6Az5Nykfb3c42fd";
  final String apiUrl = "https://admin.uthix.com/api/classroom";

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

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
          isLoading = false;
        });
      } else {
        print("Error: ${response.data["message"]}");
        setState(() {
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
          return Padding(
            padding: const EdgeInsets.only(
                top: 15, left: 20,right: 20,bottom: 15),
            child: GestureDetector(
              onTap: () {
                // Navigate to the new class screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Newclass(),
                  ),
                );
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
                          const Spacer(),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                      // Subject information.
                      Text(
                        "Subject ID: ${classItem['subject_id']?.toString() ?? 'N/A'}",
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(1.0),
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(1.0),
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(1.0),
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(1.0),
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
                              // Navigate to Add Chapter page.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const Newclass()),
                              );
                            },
                            child: Container(
                              height: 39,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color.fromRGBO(43, 92, 116, 1),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Add Chapter",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(43, 92, 116, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyClasses()),
                              );
                            },
                            child: Container(
                              height: 39,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color.fromRGBO(43, 92, 116, 1),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "View All Details",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(43, 92, 116, 1),
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
