import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/class.dart';

class MyClasses extends StatefulWidget {
  final String classroomId; // Add the classroomId parameter

  const MyClasses({super.key, required this.classroomId});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  final TextEditingController _emailController = TextEditingController();
  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/manage-classes";
  String? token;
  List<dynamic> classes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load token from SharedPreferences using the key "auth_token"
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    debugPrint("Token loaded: $token");
    if (token != null) {
      await _fetchClassroom();
    } else {
      debugPrint("Access token not found. User may not be logged in.");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchClassroom() async {
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          classes = response.data['data'];
          isLoading = false;
        });
      } else {
        debugPrint("Error: ${response.data["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching classes: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter chapters for the given classroom id.
  List<dynamic> get filteredClasses {
    return classes.where((chapter) {
      if (chapter["classroom"] != null && chapter["classroom"]["id"] != null) {
        return chapter["classroom"]["id"].toString() == widget.classroomId;
      }
      return false;
    }).toList();
  }

  // Modal to invite a participant (can be reused as needed)
  void showCenteredModal() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Add Participant",
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
                  width: 394,
                  height: 383,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Email Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(43, 92, 116, 1),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              height: 45,
                              width: 270,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 246, 246, 1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Color.fromRGBO(210, 210, 210, 1)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(96, 95, 95, 1),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "eg., xyz@gmail.com",
                                    hintStyle: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(96, 95, 95, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 45,
                              width: 62,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(43, 92, 116, 1),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Center(
                                child: Text(
                                  "Invite",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 45),
                        Container(
                          height: 186,
                          width: 341,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 64,
                                      width: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(43, 92, 116, 1),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                            "assets/instructor/link.png"),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    const Text(
                                      "Class invitation Link",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(43, 92, 116, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 37,
                                      width: 151,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(43, 92, 116, 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 30),
                                          Image.asset(
                                              "assets/instructor/share-outline.png"),
                                          const SizedBox(width: 5),
                                          const Text(
                                            "Share",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 37,
                                      width: 151,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(43, 92, 116, 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 30),
                                          Image.asset(
                                              "assets/instructor/content-copy.png"),
                                          const SizedBox(width: 5),
                                          const Text(
                                            "Copy",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
                  "My Classes",
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
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classItem = classes[index];
          // Extract the class's unique ID (assuming it's in classItem['id'])
          final classId = classItem['id'].toString();
          return Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
            child: GestureDetector(
              onTap: () {
                // Navigate to the InstructorClass page, passing the classId so that only chapters for this classroom are shown.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructorClass(classId: classId),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
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
                      Row(
                        children: [
                          Text(
                            classItem['classroom']['class_name'] ??
                                "Unknown Class",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            classItem['classroom']['section'] ?? "No section",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        classItem['classroom']['subject']['name'] ??
                            "No subject found",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        classItem['title'] ?? "No title",
                        style: GoogleFonts.urbanist(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
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
                                    decoration: BoxDecoration(
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
                                    decoration: BoxDecoration(
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
                                    decoration: BoxDecoration(
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              showCenteredModal();
                            },
                            child: Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color.fromRGBO(43, 92, 116, 1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    color: Color.fromRGBO(43, 92, 116, 1),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    "Add Participant",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(43, 92, 116, 1),
                                    ),
                                  ),
                                ],
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
