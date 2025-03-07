import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/class.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({super.key});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  final TextEditingController _emailController = TextEditingController();
  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/manage-classes";
  final String token = "3|SkCLy7WfUwBHDUD0B2KSBi6JiGmji7aqbQDhr7Oa0f78c8bf";
  List<dynamic> classes = [];

  @override
  void initState() {
    super.initState();
    _fetchClassroom();
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

      print("Response Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          classes = response.data['data'];
        });
      }
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

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
                        const SizedBox(
                          height: 2,
                        ),
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
                                  keyboardType: TextInputType.phone,
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
                            Spacer(),
                            Container(
                              height: 45,
                              width: 62,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(43, 92, 116, 1),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Center(
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
                        const SizedBox(
                          height: 45,
                        ),
                        Container(
                          height: 176,
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
                                              "assets/instructor/link.png")),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Class invitation Link",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(43, 92, 116, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
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
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Image.asset(
                                              "assets/instructor/share-outline.png"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
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
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Image.asset(
                                              "assets/instructor/content-copy.png"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
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
      body: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            color: Color.fromRGBO(43, 92, 116, 1),
            child: Padding(
              padding: const EdgeInsets.all(14),
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
                  Text(
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
                    decoration: BoxDecoration(
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
          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final classItem = classes[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstructorClass(),
                        ),
                      );
                    },
                    child: Container(
                      width: 340,
                      height: 152,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        color: Color.fromRGBO(246, 246, 246, 1),
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
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    classItem['classroom']['section'] ??
                                        "No section ",
                                    style: GoogleFonts.urbanist(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Icon(Icons.more_vert),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                                classItem['classroom']['subject']['name'] ??
                                    "No subject found ",
                                style: GoogleFonts.urbanist(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 5),
                            Text(classItem['title'] ?? "No title",
                                style: GoogleFonts.urbanist(fontSize: 14)),
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
                                              color: Colors.black),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ClipOval(
                                              child: Image.asset(
                                                  "assets/login/profile.jpeg",
                                                  fit: BoxFit.cover),
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
                                              color: Colors.black),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ClipOval(
                                              child: Image.asset(
                                                  "assets/login/profile.jpeg",
                                                  fit: BoxFit.cover),
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
                                              color: Colors.black),
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
                                              color: Colors.black),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ClipOval(
                                              child: Image.asset(
                                                  "assets/login/profile.jpeg",
                                                  fit: BoxFit.cover),
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
                                    height: 39,
                                    width: 126,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color.fromRGBO(43, 92, 116, 1),
                                          width: 1),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color:
                                                Color.fromRGBO(43, 92, 116, 1),
                                            //size: 5,
                                          ),
                                          Text(
                                            "Add Participant",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  43, 92, 116, 1),
                                            ),
                                          ),
                                        ],
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
          ),
        ],
      ),
    );
  }
}
