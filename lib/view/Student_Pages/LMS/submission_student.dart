// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/LMS/live_student.dart';
import 'package:uthix_app/view/Student_Pages/LMS/submission_student.dart'; // For navigation if needed

class SubmissionStudent extends StatefulWidget {
  final String announcementId;
  final String chapterId;
  const SubmissionStudent({
    Key? key,
    required this.announcementId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<SubmissionStudent> createState() => _SubmissionStudentState();
}

class _SubmissionStudentState extends State<SubmissionStudent> {
  final Dio _dio = Dio();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Color(0xFFE0EAF3), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(96, 95, 95, 1),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Due: 20 Jan 2025",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(96, 95, 95, 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Submit your Report here",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // "Add Your Work" button at the bottom.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: GestureDetector(
                onTap: () {
                  // Show bottom sheet for file selection and upload.
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return UploadBottomSheet(
                        announcementId: widget.announcementId,
                        chapterId: widget.chapterId,
                        token: token ?? "",
                        dio: _dio,
                      );
                    },
                  );
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(43, 96, 116, 1),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Center(
                    child: Text(
                      "+ ADD YOUR WORK",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadBottomSheet extends StatefulWidget {
  final String announcementId;
  final String chapterId;
  final String token;
  final Dio dio;

  const UploadBottomSheet({
    Key? key,
    required this.announcementId,
    required this.chapterId,
    required this.token,
    required this.dio,
  }) : super(key: key);

  @override
  _UploadBottomSheetState createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  bool isUploading = false;
  String? _selectedFilePath;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    // Open file picker for the user to select a file.
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  Future<void> _uploadAssignment() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please choose a file to upload.")),
      );
      return;
    }
    setState(() {
      isUploading = true;
    });
    try {
      String uploadUrl = "https://admin.uthix.com/api/announcements/${widget.announcementId}/assignments";
      FormData formData = FormData.fromMap({
        "announcement_id": widget.announcementId,
        "chapter_id": widget.chapterId,
        "title": _titleController.text, // Submission title field.
        "attachments[]": await MultipartFile.fromFile(
          _selectedFilePath!,
          filename: _selectedFilePath!.split('/').last,
        ),
      });
      final response = await widget.dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      log("Upload Response: ${response.data}");
      if (response.data["message"] != null &&
          response.data["message"].toString().contains("successfully")) {
        Navigator.pop(context); // Close bottom sheet.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File upload failed")),
        );
      }
    } catch (e) {
      log("Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File upload failed")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // This padding ensures the bottom sheet adjusts for the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Container(
        color: Colors.white, // White background.
        padding: EdgeInsets.all(16),
        // Removed fixed height to allow scrolling.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Upload Assignment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            // Text input field for the submission title.
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Submission Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _selectedFilePath != null
                ? Text("Selected File: ${_selectedFilePath!}")
                : Text("No file selected"),
            SizedBox(height: 16),
            // Button to open file picker.
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              child: Text("Choose File", style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
            SizedBox(height: 16),
            // Upload button.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(43, 96, 116, 1),
              ),
              onPressed: isUploading ? null : _uploadAssignment,
              child: isUploading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text("Upload", style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}



