import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../modal/Snackbar.dart';

class NewAnnouncement extends StatefulWidget {
  final String classId;

  const NewAnnouncement({Key? key, required this.classId}) : super(key: key);

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final TextEditingController _announceController = TextEditingController();
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
    token = prefs.getString('auth_token');
    if (token == null) {
      SnackbarHelper.showMessage(
        context,
        message: "Access token not found.",
      );
    }
  }

  Future<void> _pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFiles = result.paths.whereType<String>().map((p) => File(p)).toList();
        });
      }
    } catch (e) {
      SnackbarHelper.showMessage(context, message: "Error picking files: $e");
    }
  }

  Future<void> _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2B5C74),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _postAnnouncement() async {
    final text = _announceController.text.trim();
    if (text.isEmpty) {
      SnackbarHelper.showMessage(
        context,
        message: "Announcement text cannot be empty.",
      );
      return;
    }
    if (token == null) {
      // Already handled in _loadToken
      return;
    }

    final url = "$baseUrl${widget.classId}/announcements";
    String? due = _dueDate != null ? DateFormat("dd-MM-yy").format(_dueDate!) : null;

    final dataMap = {
      "title": text,
      "due_date": due,
      if (_selectedFiles.isNotEmpty)
        "attachments[]": await Future.wait(
          _selectedFiles.map((f) => MultipartFile.fromFile(
            f.path,
            filename: f.path.split('/').last,
          )),
        ),
    };

    FormData formData = FormData.fromMap(dataMap);

    try {
      final resp = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final d = resp.data as Map<String, dynamic>;
        if (d["status"] == true) {
          SnackbarHelper.showMessage(
            context,
            message: 'Announcement posted successfully!',
          );
          Navigator.pop(context);
        } else {
          SnackbarHelper.showMessage(
            context,
            message: d["message"] ?? "Failed to post announcement.",
          );
        }
      } else {
        SnackbarHelper.showMessage(
          context,
          message: "Failed with status: ${resp.statusCode}",
        );
      }
    } catch (e) {
      SnackbarHelper.showMessage(
        context,
        message: "Error posting announcement: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black, size: 25.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Announcement",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            children: [
              // Post button
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: _postAnnouncement,
                    child: Container(
                      height: 40.h,
                      width: 80.w,
                      color: const Color(0xFF2B5C74),
                      child: Center(
                        child: Text("Post", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Divider(color: const Color(0xFFD9D9D9)),
              // Announcement field
              Row(
                children: [
                  Icon(Icons.menu, color: const Color(0xFF2B5C74)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _announceController,
                      decoration: InputDecoration(
                        hintText: "Announce something to your class",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: const Color(0xFFD9D9D9)),
              // Attachments
              GestureDetector(
                onTap: _pickAttachment,
                child: Row(
                  children: [
                    Icon(Icons.link, color: const Color(0xFF2B5C74)),
                    SizedBox(width: 10.w),
                    Text("Add Attachment", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              if (_selectedFiles.isNotEmpty) ...[
                SizedBox(height: 8.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200.h),
                  child: ListView.builder(
                    itemCount: _selectedFiles.length,
                    itemBuilder: (_, i) => Padding(
                      padding: EdgeInsets.only(left: 40.w, bottom: 8.h),
                      child: Text(
                        _selectedFiles[i].path.split('/').last,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
              Divider(color: const Color(0xFFD9D9D9)),
              // Due date
              GestureDetector(
                onTap: _pickDueDate,
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: const Color(0xFF2B5C74)),
                    SizedBox(width: 10.w),
                    Text(
                      _dueDate == null
                          ? "Due Date"
                          : "Due Date: ${DateFormat("dd-MM-yy").format(_dueDate!)}",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Divider(color: const Color(0xFFD9D9D9)),
            ],
          ),
        ),
      ),
    );
  }
}
