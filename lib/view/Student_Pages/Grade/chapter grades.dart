import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'grade.dart';

class AllSubmissionsScreen extends StatefulWidget {
  const AllSubmissionsScreen({super.key});

  @override
  State<AllSubmissionsScreen> createState() => _AllSubmissionsScreenState();
}

class _AllSubmissionsScreenState extends State<AllSubmissionsScreen> {
  List<Submission> submissions = [];
  bool isLoading = true;
  String? accessLoginToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
    await fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $accessLoginToken';

      final response =
      await dio.get('https://admin.uthix.com/api/submissions/class');

      if (response.data['status'] == true) {
        final data = response.data['data'] as List;

        List<Submission> sortedList = data
            .map((json) => Submission.fromJson(json))
            .toList();

// Sort by submitted_at in descending order
        sortedList.sort((a, b) {
          DateTime dateA = DateTime.tryParse(a.dateTime) ?? DateTime(2000);
          DateTime dateB = DateTime.tryParse(b.dateTime) ?? DateTime(2000);
          return dateB.compareTo(dateA); // Newest first
        });

        setState(() {
          submissions = sortedList;
          isLoading = false;
        });
      } else {
        print('[log] ❌ API returned status false');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("[log] 🔥 Error in fetchSubmissions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "All Submissions",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : submissions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/instructor/UnableToLoadData.png', // ✅ Make sure this image exists in assets folder
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Submissions Found',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          final submission = submissions[index];
          return Card(
            color: const Color(0xFFF6F6F6),
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey, width: 0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Time: ${submission.dateTime.isNotEmpty ? submission.dateTime : 'N/A'}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GradeStudent(assignmentUploadId: submission.assignmentUploadId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF325A6A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                        ),
                        child: const Text(
                          "View Grades",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Subject : ${submission.subject}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  Text("Chapter : ${submission.chapter}"),
                  Text("Announcement : ${submission.announcement}"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: submission.attachments.map((filePath) {
                      final fileName = filePath.split('/').last;
                      return PdfTagButton(
                        label: fileName,
                        url:
                        'https://admin.uthix.com/storage/$filePath',
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PdfTagButton extends StatelessWidget {
  final String label;
  final String url;

  const PdfTagButton({super.key, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open file')),
          );
        }
      },
      icon: const Icon(Icons.attach_file, size: 16),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}

class Submission {
  final int assignmentUploadId;
  final String subject;
  final String chapter;
  final String announcement;
  final String dateTime;
  final List<String> attachments;

  Submission({
    required this.assignmentUploadId,
    required this.subject,
    required this.chapter,
    required this.announcement,
    required this.dateTime,
    required this.attachments,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    final upload = (json['uploads'] as List).isNotEmpty
        ? json['uploads'][0]
        : null;

    return Submission(
      assignmentUploadId: (upload != null && upload['id'] != null)
          ? upload['id'] as int
          : 0,
      subject: json['title'] ?? 'N/A',
      chapter: 'Chapter ${json['chapter_id'] ?? 'N/A'}',
      announcement: json['title'] ?? 'N/A',
      dateTime: upload?['submitted_at'] ?? '',
      attachments: (upload?['attachments'] as List?)
          ?.map((a) => a['attachment_file'].toString())
          .toList() ??
          [],
    );
  }
}