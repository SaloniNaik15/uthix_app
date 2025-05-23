import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modal/Snackbar.dart';

class Newclass extends StatefulWidget {
  final String classroomId;

  const Newclass({Key? key, required this.classroomId}) : super(key: key);

  @override
  State<Newclass> createState() => _NewclassState();
}

class _NewclassState extends State<Newclass> {
  DateTime? _selectdate;
  TimeOfDay? _selectTime;
  final Dio _dio = Dio();
  String? token;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool sendReminder = false;

  // For fetching chapters for this classroom
  List<dynamic> chapters = [];
  bool chaptersLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Fetch the token from SharedPreferences using the key "auth_token"
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    debugPrint("Token loaded: $token");
    // Once token is loaded, fetch any existing chapters for this classroom.
    if (token != null) {
      _fetchChapters();
    }
  }

  Future<void> _createClassroom() async {
    if (titleController.text.trim().isEmpty ||
        _selectdate == null ||
        _selectTime == null) {
      SnackbarHelper.showMessage(
        context,
        message: "Please fill all required fields.",
      );
      return;
    }

    final requestData = {
      "title": titleController.text.trim(),
      "date": DateFormat('yyyy-MM-dd').format(_selectdate!),
      "time":
      "${_selectTime!.hour.toString().padLeft(2, '0')}:${_selectTime!.minute.toString().padLeft(2, '0')}:00",
      "timezone": "IST",
      "description": descriptionController.text.trim(),
    };

    debugPrint("Request Data: ${jsonEncode(requestData)}");

    final endpoint =
        "https://admin.uthix.com/api/class-chapter/${widget.classroomId}";

    try {
      final response = await _dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");

      if (response.statusCode == 201 && response.data["status"] == true) {
        SnackbarHelper.showMessage(
          context,
          message: "Chapter created successfully!",
        );
        // Clear inputs
        titleController.clear();
        descriptionController.clear();
        setState(() {
          _selectdate = null;
          _selectTime = null;
        });
        _fetchChapters();
      } else {
        SnackbarHelper.showMessage(
          context,
          message: "Failed to create chapter.",
        );
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio Error Code: ${e.response?.statusCode}");
        debugPrint("Dio Response Data: ${e.response?.data}");
        SnackbarHelper.showMessage(
          context,
          message: "Error: ${e.response?.data}",
        );
      } else {
        SnackbarHelper.showMessage(
          context,
          message: "Unexpected Error: ${e.toString()}",
        );
      }
    }
  }


  // Fetch chapters for this classroom using the classroomId.
  Future<void> _fetchChapters() async {
    final String endpoint =
        "https://admin.uthix.com/api/class-chapter/${widget.classroomId}";
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          chapters = response.data["data"] ?? [];
          chaptersLoading = false;
        });
      } else {
        debugPrint("Error fetching chapters: ${response.data["message"]}");
        setState(() {
          chaptersLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching chapters: $e");
      setState(() {
        chaptersLoading = false;
      });
    }
  }

  Future<void> _pickDatefunc() async {
    DateTime? pickdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2B5C74),
              onPrimary: Colors.white, // text color on selected date
              onSurface: Colors.black, // text color
              background: Colors.white, // background color
            ),
            dialogBackgroundColor: Colors.white, // full dialog background
          ),
          child: child!,
        );
      },
    );
    setState(() {
      _selectdate = pickdate;
    });
  }

  Future<void> _selectTimefunc() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white,
              dialHandColor: Color(0xFF2B5C74),
              hourMinuteTextColor: Colors.black,
              dialTextColor: Colors.black,
              entryModeIconColor:Color(0xFF2B5C74),
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2B5C74),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectTime = picked;
      });
    }
  }


  Widget _buildOptionRow(IconData icon, String title, String value,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description, color: Colors.black, size: 22),
            const SizedBox(width: 12),
            Text(
              "Add Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter class description...",
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              Text(
                "Add new Chapter to class",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Add Title",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionRow(
                Icons.calendar_today,
                "Pick a Date",
                _selectdate != null
                    ? DateFormat('EEE, dd MMM, yyyy').format(_selectdate!)
                    : "",
                _pickDatefunc,
              ),
              const SizedBox(height: 20),
              _buildOptionRow(
                Icons.access_time,
                "Pick a Time",
                _selectTime != null
                    ? DateFormat('hh:mm a').format(DateTime(
                        2025, 1, 1, _selectTime!.hour, _selectTime!.minute))
                    : "",
                _selectTimefunc,
              ),
              const SizedBox(height: 20),
              _buildOptionRow(Icons.public, "Indian Standard Time", ""),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildOptionRow(Icons.group_add, "Invite People", ""),
              const SizedBox(height: 20),
              Divider(color: Colors.grey.shade300, thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: sendReminder,
                      onChanged: (bool? value) {
                        setState(() {
                          sendReminder = value!;
                        });
                      },
                      activeColor: const Color(0xFF2B5C74),
                    ),
                    Expanded(
                      child: Text(
                        "Send Class Reminder to everyone in the Class",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF605F5F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: _createClassroom,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF2B5C74),
                    ),
                    child: Center(
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 16,
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
      ),
    );
  }
}
