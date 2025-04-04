// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/UpcomingPage.dart';

import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Files/recording.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';
import 'package:uthix_app/view/instructor_dashboard/files/recording.dart';
import 'package:uthix_app/view/instructor_dashboard/files/upload.dart';

class StudFiles extends StatefulWidget {
  const StudFiles({super.key});

  @override
  State<StudFiles> createState() => _StudFilesState();
}

class _StudFilesState extends State<StudFiles> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 1;
        });
      });
    }
  }

  //Now list of maps used.
  final List<Map<String, String>> files = [
    {
      "assetPath": "assets/files_icons/recording_file.png",
      "title": "Recordings",
      "description": "61 GB, Modified by Instructor on 13/01/2025",
    },
    {
      "assetPath": "assets/files_icons/document_pdf.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },
    {
      "assetPath": "assets/files_icons/image.png",
      "title": "Images",
      "description": "8 GB, Modified by User on 05/01/2025",
    },

    {
      "assetPath": "assets/files_icons/image.png",
      "title": "Images",
      "description": "8 GB, Modified by User on 05/01/2025",
    },
    {
      "assetPath": "assets/files_icons/document_pdf.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },
    {
      "assetPath": "assets/files_icons/image.png",
      "title": "Images",
      "description": "8 GB, Modified by User on 05/01/2025",
    },
    {
      "assetPath": "assets/files_icons/video.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },

  ];

  List<String> sortOptions = ["Newest", "Oldest", "A-Z"];
  int sortopt = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
        elevation: 0,
        title: Text(
          "Files",
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined,
              color: Colors.white, size: 20.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "The class recordings and files uploaded by you will appear here",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          sortOptions.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                                right:
                                    index < sortOptions.length - 1 ? 10 : 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                height: 45.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  color: selectedIndex == index
                                      ? Color.fromRGBO(43, 92, 116, 1)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: Colors.grey, width: 2.w),
                                ),
                                child: Center(
                                  child: Text(
                                    sortOptions[index],
                                    style:TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: 85), // Prevents overlap with navbar
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            if (file["title"] == "Recordings") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudRecording()),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                                height: 40.h,
                                child: Image.asset(
                                  file["assetPath"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file["title"]!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                    Text(
                                      file["description"]!,
                                      style:TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // Fixed Bottom Navigation Bar inside Stack
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: NavbarStudent(
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
