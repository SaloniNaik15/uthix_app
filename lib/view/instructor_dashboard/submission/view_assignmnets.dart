import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'grade.dart'; // Adjust this import if your Grade page is in a different location.

class ViewAssignmnets extends StatefulWidget {
  final String announcementId;

  const ViewAssignmnets({Key? key, required this.announcementId}) : super(key: key);

  @override
  State<ViewAssignmnets> createState() => _ViewAssignmnetsState();
}

class _ViewAssignmnetsState extends State<ViewAssignmnets> {
  bool isLoading = true;
  int totalSubmissions = 0;
  List<dynamic> uploads = [];
  String? token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchSubmissions();
  }

  /// Loads the token from SharedPreferences and then fetches submissions.
  Future<void> _loadTokenAndFetchSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint("No token found. Please log in again.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    await _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    final String url =
        "https://admin.uthix.com/api/assignments/${widget.announcementId}/submissions";

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response data: ${response.data}");


      if (response.statusCode == 200 && response.data["status"] == true) {
        final assignment = response.data["assignment"];
        setState(() {
          totalSubmissions = assignment["total_submissions"] ?? 0;
          uploads = assignment["uploads"] ?? [];
        });
      } else {
        debugPrint("Error: Invalid submission response");
      }
    } catch (e) {
      debugPrint("Error fetching submissions: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openAttachment(String attachmentUrl) async {
    final Uri url = Uri.parse(attachmentUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $attachmentUrl");
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
        title: Column(
          children: [
            Text(
              "All Submissions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
            Text(
              "$totalSubmissions submissions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : uploads.isEmpty
          ? Center(
        child: Text("No submissions found.", style: TextStyle(fontSize: 16)),
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: uploads.length,
          itemBuilder: (context, index) {
            final upload = uploads[index];
            final student = upload["student"];
            final studentName = student?["name"] ?? "No Name";
            final profileImage = student?["profile_image"];
            // Placeholder as the API doesn't provide class info.
            final studentClass = "X B";
            final submissionDescription =
                upload["title"] ?? (upload["comment"] ?? "No Description");
            final attachments = upload["attachments"] as List<dynamic>? ?? [];
            final hasAttachment = attachments.isNotEmpty;
            final filePath = hasAttachment ? attachments[0]["file_path"] ?? "" : "";
            final fileName = filePath.isNotEmpty ? filePath.split("/").last : "No attachment";
            final attachmentUrl = filePath.isNotEmpty
                ? "https://admin.uthix.com/storage/$filePath"
                : "";

            return Padding(
              padding: EdgeInsets.only(bottom: 15,),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(246, 246, 246, 1),
                  border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Profile image, Student name, and Grade button.
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: (profileImage != null)
                                ? NetworkImage(profileImage)
                                : null,
                            child: (profileImage == null)
                                ? Text(
                              studentName.isNotEmpty ? studentName[0] : "N",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                                : null,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: $studentName",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Class: $studentClass",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Grade(
                                    uploadId: upload["id"].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 37.h,
                              width: 85.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color: const Color.fromRGBO(43, 92, 116, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Grade",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Submission description.
                      Text(
                        "Description: $submissionDescription",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Attachment column: each attachment appears on its own line.
                      if (hasAttachment)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: attachments.map<Widget>((att) {
                            final filePath = att["file_path"] ?? "";
                            final fileName = filePath.isNotEmpty ? filePath.split("/").last : "No attachment";
                            final attachmentUrl = filePath.isNotEmpty
                                ? "https://admin.uthix.com/storage/$filePath"
                                : "";
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: GestureDetector(
                                onTap: () {
                                  if (attachmentUrl.isNotEmpty) {
                                    _openAttachment(attachmentUrl);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.insert_drive_file, size: 14.sp, color: Colors.grey.shade600),
                                      Text(
                                        fileName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: const Color.fromRGBO(96, 95, 95, 1),
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}