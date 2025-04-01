import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NewAnnouncement extends StatefulWidget {
  final String classId;

  const NewAnnouncement({Key? key, required this.classId}) : super(key: key);

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final TextEditingController _announceController = TextEditingController();

  // Base API URL; we'll append the classId and '/announcements'
  final String baseUrl = "https://admin.uthix.com/api/chapters/";

  String? token;
  List<File> _selectedFiles = [];
  DateTime? _dueDate;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token == null) {
      debugPrint("No token found. User may not be logged in.");
    }
  }

  /// Allows the user to pick multiple files for attachment.
  Future<void> _pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFiles = result.paths
              .whereType<String>()
              .map((path) => File(path))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  /// Posts the announcement (with multiple attachments) to the specific chapter endpoint.
  Future<void> _postAnnouncement() async {
    final announcementText = _announceController.text.trim();

    if (announcementText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Announcement text cannot be empty.")),
      );
      return;
    }

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token not found.")),
      );
      return;
    }

    // Construct the endpoint URL using the provided classId.
    final String postUrl = "${baseUrl}${widget.classId}/announcements";

    // Format the due date as dd-MM-yy if one is selected.
    String? formattedDueDate;
    if (_dueDate != null) {
      formattedDueDate = DateFormat("dd-MM-yy").format(_dueDate!);
    }

    // Prepare form data.
    final Map<String, dynamic> formMap = {
      "title": announcementText,
      "due_date": formattedDueDate,
    };

    // If files are selected, add them to attachments[] as a list.
    if (_selectedFiles.isNotEmpty) {
      formMap["attachments[]"] = await Future.wait(
        _selectedFiles.map((file) async => await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        )),
      );
    }

    FormData formData = FormData.fromMap(formMap);

    try {
      final response = await _dio.post(
        postUrl,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"] ?? "Posted successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"] ?? "Failed to post.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed with status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error posting announcement: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Opens a date picker to select an optional due date.
  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Entire background white.
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 25.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("New Announcement"),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            children: [
              // "Post" button row.
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: _postAnnouncement,
                    child: Container(
                      height: 40.h,
                      width: 80.w,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              // Announcement text input.
              Row(
                children: [
                  const Icon(Icons.menu, color: Color.fromRGBO(43, 92, 116, 1)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _announceController,
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Announce something to your class",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              // Add attachment.
              GestureDetector(
                onTap: _pickAttachment,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link, color: Color.fromRGBO(43, 92, 116, 1)),
                        SizedBox(width: 10.w),
                        Text(
                          "Add Attachment",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    if (_selectedFiles.isNotEmpty)
                      Container(
                        // Set a maximum height; adjust as needed.
                        constraints: BoxConstraints(maxHeight: 300.h),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _selectedFiles.length,
                          separatorBuilder: (context, index) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final file = _selectedFiles[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 40.w),
                              child: Text(
                                file.path.split('/').last,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              // Due date picker.
              GestureDetector(
                onTap: _pickDueDate,
                child: Row(
                  children: [
                    const Icon(Icons.alarm, color: Color.fromRGBO(43, 92, 116, 1)),
                    SizedBox(width: 10.w),
                    Text(
                      _dueDate == null
                          ? "Due Date"
                          : "Due Date: ${DateFormat("dd-MM-yy").format(_dueDate!)}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
