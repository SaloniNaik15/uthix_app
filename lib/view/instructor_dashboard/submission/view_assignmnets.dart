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
  /// Indicates whether data is still loading.
  bool isLoading = true;

  /// Total number of submissions from the API response.
  int totalSubmissions = 0;

  /// A list of submissions from the API. Each submission is a JSON object.
  List<dynamic> uploads = [];

  /// Token for authorization (fetched from SharedPreferences).
  String? token;

  /// Cache key used to store the API response.
  String get cacheKey => "assignment_submission_${widget.announcementId}";

  @override
  void initState() {
    super.initState();
    _loadTokenAndCacheData();
  }

  /// Loads the token and cached submission data from SharedPreferences.
  Future<void> _loadTokenAndCacheData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint("No token found. Please log in again.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Try to load cached data.
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final Map<String, dynamic> assignment = jsonDecode(cachedData);
        setState(() {
          totalSubmissions = assignment["total_submissions"] ?? 0;
          uploads = assignment["uploads"] ?? [];
          isLoading = false;
        });
      } catch (e) {
        debugPrint("Error decoding cached data: $e");
      }
    }

    // Fetch fresh data in background.
    await _fetchSubmissions();
  }

  /// Fetches the submissions for the given announcementId from your API.
  Future<void> _fetchSubmissions() async {
    final String url =
        "https://admin.uthix.com/api/assignments/${widget.announcementId}/submission";

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

      // Expected API response structure:
      // {
      //   "status": true,
      //   "assignment": {
      //       "id": 29,
      //       "title": "complete differentiation",
      //       "due_date": "2031-03-25",
      //       "total_submissions": 3,
      //       "uploads": [ { ... }, { ... }, { ... } ]
      //   }
      // }
      if (response.statusCode == 200 && response.data["status"] == true) {
        final assignment = response.data["assignment"];
        setState(() {
          totalSubmissions = assignment["total_submissions"] ?? 0;
          uploads = assignment["uploads"] ?? [];
        });
        // Update the cache.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(cacheKey, jsonEncode(assignment));
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

  /// Opens the attachment URL using url_launcher.
  Future<void> _openAttachment(String attachmentUrl) async {
    final Uri url = Uri.parse(attachmentUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch $attachmentUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 25.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              Text(
                "All Submissions",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              Text(
                "$totalSubmissions submissions",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : uploads.isEmpty
          ? Center(
        child: Text(
          "No submissions found.",
          style: TextStyle(fontSize: 16.sp),
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: ListView.builder(
          itemCount: uploads.length,
          itemBuilder: (context, index) {
            final upload = uploads[index];

            final student = upload["student"];
            final studentName = student?["name"] ?? "No Name";
            final profileImage = student?["profile_image"];
            final studentClass = "Class: X B"; // Placeholder

            final submissionDescription = upload["title"] ??
                (upload["comment"] ?? "No Description");

            final attachments = upload["attachments"] as List<dynamic>? ?? [];
            final hasAttachment = attachments.isNotEmpty;
            final filePath = hasAttachment
                ? attachments[0]["file_path"] ?? ""
                : "";
            final fileName = filePath.isNotEmpty
                ? filePath.split("/").last
                : "No attachment";
            final attachmentUrl = filePath.isNotEmpty
                ? "https://admin.uthix.com/$filePath"
                : "";

            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Container(
                height: 203.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(246, 246, 246, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.h),
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
                              studentName.isNotEmpty
                                  ? studentName[0]
                                  : "N",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white),
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
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Class: $studentClass",
                                style: TextStyle(
                                  fontSize: 12.sp,
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
                                  builder: (context) => Grade(),
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
                                    fontSize: 14.sp,
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Attachment row.
                      if (hasAttachment)
                        GestureDetector(
                          onTap: () {
                            if (attachmentUrl.isNotEmpty) {
                              _openAttachment(attachmentUrl);
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 26.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(13.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Transform.rotate(
                                      angle: 45 * 3.1415927 / 180,
                                      child: Image.asset(
                                        "assets/instructor/link.png",
                                        scale: 2,
                                        color: const Color.fromRGBO(96, 95, 94, 1),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        fileName,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300,
                                          color: const Color.fromRGBO(96, 95, 95, 1),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
