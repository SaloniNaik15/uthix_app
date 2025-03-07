import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Newclass extends StatefulWidget {
  const Newclass({super.key});

  @override
  State<Newclass> createState() => _NewclassState();
}

class _NewclassState extends State<Newclass> {
  DateTime? _selectdate;
  TimeOfDay? _selectTime;
  final Dio _dio = Dio();
  final String apiUrl = "https://admin.uthix.com/api/class-chapter";
  final String token = "3|SkCLy7WfUwBHDUD0B2KSBi6JiGmji7aqbQDhr7Oa0f78c8bf";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool sendReminder = false;

  Future<void> _createClassroom() async {
    if (titleController.text.trim().isEmpty ||
        _selectdate == null ||
        _selectTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      "classroom_id": 2,
      "title": titleController.text.trim(),
      "date": DateFormat('yyyy-MM-dd').format(_selectdate!),
      "time":
          "${_selectTime!.hour.toString().padLeft(2, '0')}:${_selectTime!.minute.toString().padLeft(2, '0')}:00",
      "timezone": "IST",
      "description": descriptionController.text.trim(),
    };

    print("Request Data: ${jsonEncode(requestData)}");

    try {
      final response = await _dio.post(
        apiUrl,
        data: requestData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 201 && response.data["status"]) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Classroom created successfully!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${response.data['message']}")),
          );
        }
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio Error Code: ${e.response?.statusCode}");
        print("Dio Response Data: ${e.response?.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.response?.data}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected Error: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _pickDatefunc() async {
    DateTime? pickdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickdate != null) {
      setState(() {
        _selectdate = pickdate;
      });
    }
  }

  Future<void> _selectTimefunc() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              Text("Start a New Class",
                  style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Add Title",
                  hintStyle: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
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
                  _pickDatefunc),
              const SizedBox(height: 20),
              _buildOptionRow(
                  Icons.access_time,
                  "Pick a Time",
                  _selectTime != null
                      ? DateFormat('hh:mm a').format(DateTime(
                          2025, 1, 1, _selectTime!.hour, _selectTime!.minute))
                      : "",
                  _selectTimefunc),
              const SizedBox(height: 20),
              _buildOptionRow(Icons.public, "Indian Standard Time", ""),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildOptionRow(Icons.group_add, "Invite People", ""),
              const SizedBox(height: 20),

              // Full-width divider
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
                      activeColor: Color(0xFF2B5C74),
                    ),
                    Expanded(
                      child: Text(
                          "Send Class Reminder to everyone in the Class",
                          style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF605F5F))),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 40),

              // Save Button
              Center(
                child: GestureDetector(
                  onTap: _createClassroom,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF2B5C74),
                    ),
                    child: Center(
                      child: Text("SAVE",
                          style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String title, String value,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          const SizedBox(width: 12),
          Text(title,
              style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          const Spacer(),
          if (value.isNotEmpty)
            Text(value,
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue)),
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
            Text("Add Description",
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter class description...",
            hintStyle: GoogleFonts.urbanist(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
