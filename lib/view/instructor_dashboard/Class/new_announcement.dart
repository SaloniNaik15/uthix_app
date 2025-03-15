import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({Key? key}) : super(key: key);

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final TextEditingController _announceController = TextEditingController();

  // Ensure the endpoint URL matches your backend. Check for typos if needed.
  final String apiUrl = "https://admin.uthix.com/api/announcement";
  String? token; // Token will be loaded from SharedPreferences

  File? _selectedFile;

  final String instructorId = "2";
  final String classroomId = "1";
  DateTime? _dueDate;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  /// Loads the access token from SharedPreferences using the key "auth_token".
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token == null) {
      debugPrint("No token found. User may not be logged in.");
    }
  }

  /// Picks a single file from the device.
  Future<void> _pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // For multiple files, if needed
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  /// Sends the announcement and selected file(s) to the server.
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

    // Prepare multipart form data
    FormData formData = FormData.fromMap({
      "instructor_id": instructorId,
      "classroom_id": classroomId,
      "title": announcementText,
      // If your API expects a due date, include it here
      "due_date": _dueDate != null ? _dueDate!.toIso8601String() : null,
      // Send file attachment if one was picked. Adjust key name if required.
      if (_selectedFile != null)
        "attachments[]": await MultipartFile.fromFile(
          _selectedFile!.path,
          filename: _selectedFile!.path.split('/').last,
        ),
    });

    try {
      final response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response data: ${response.data}");

      // Check if the response JSON indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"] ?? "Posted successfully!")),
          );
          // Optionally, you can also navigate back or update your UI here.
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

  /// Optional: pick a due date from a date picker.
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top navigation and Post button
              Row(
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
                  const Spacer(),
                  GestureDetector(
                    onTap: _postAnnouncement,
                    child: Container(
                      height: 50,
                      width: 130,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Post",
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 80),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              // Announcement TextField
              Row(
                children: [
                  const Icon(Icons.menu, color: Color.fromRGBO(43, 92, 116, 1)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _announceController,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Announce something to your class",
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 16,
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
              // Add Attachment
              GestureDetector(
                onTap: _pickAttachment,
                child: Row(
                  children: [
                    const Icon(Icons.link,
                        color: Color.fromRGBO(43, 92, 116, 1)),
                    const SizedBox(width: 10),
                    Text(
                      _selectedFile == null
                          ? "Add Attachment"
                          : "Attachment: ${_selectedFile!.path.split('/').last}",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
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
              // Due Date Picker
              GestureDetector(
                onTap: _pickDueDate,
                child: Row(
                  children: [
                    const Icon(Icons.alarm,
                        color: Color.fromRGBO(43, 92, 116, 1)),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate == null
                          ? "Due Date"
                          : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0],
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
