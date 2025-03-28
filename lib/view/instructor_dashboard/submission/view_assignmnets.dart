import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/grade.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAssignmnets extends StatefulWidget {
  const ViewAssignmnets({Key? key}) : super(key: key);

  @override
  State<ViewAssignmnets> createState() => _ViewAssignmnetsState();
}

class _ViewAssignmnetsState extends State<ViewAssignmnets> {
  String? token;
  bool isLoading = true;
  int totalSubmissions = 0;
  List<dynamic> uploads = [];

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetch();
  }

  Future<void> _loadTokenAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token != null) {
      _fetchSubmissions();
    } else {
      print("No token found. User may not be logged in.");
    }
  }

  Future<void> _fetchSubmissions() async {
    try {
      final response = await Dio().get(
        'https://admin.uthix.com/api/assignments/1/submission',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          totalSubmissions = response.data["total_submissions"] ?? 0;
          uploads = response.data["uploads"] ?? [];
          isLoading = false;
        });
      } else {
        print("Error: Invalid submission response");
      }
    } catch (e) {
      print("Error fetching submissions: $e");
    }
  }

  // Function to open the attachment URL using url_launcher.
  Future<void> _openAttachment(String attachmentUrl) async {
    final Uri url = Uri.parse(attachmentUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $attachmentUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar with dynamic sizing.
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
            onPressed: () {
              Navigator.pop(context);
            },
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
                "Total $totalSubmissions out of 30",
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
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        child: ListView.builder(
          itemCount: uploads.length,
          itemBuilder: (context, index) {
            final upload = uploads[index];
            final student = upload["student"];
            final submittedAt = upload["submitted_at"] ?? "";
            final comment = upload["comment"] ?? "";
            final studentName = student["name"] ?? "No Name";
            final classInfo =
                "${student["class"] ?? ""} ${student["section"] ?? ""}";
            final attachments = upload["attachments"] as List<dynamic>?;
            final attachmentName = (attachments != null && attachments.isNotEmpty)
                ? attachments[0]["file_name"] ?? ""
                : "No attachment";
            final attachmentUrl = (attachments != null && attachments.isNotEmpty)
                ? "https://admin.uthix.com/uploads/${attachments[0]['file_path']}"
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
                      // Top row: profile image, name, submission date, Grade button.
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 39.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(1.w),
                              child: ClipOval(
                                child: (student["profile_image"] != null)
                                    ? Image.network(
                                  student["profile_image"],
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  "assets/login/profile.jpeg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                submittedAt,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromRGBO(96, 95, 95, 1),
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
                                    builder: (context) => const Grade()),
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
                      // Submission details.
                      Text(
                        "Name: $studentName",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Class: $classInfo",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        comment,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Attachment row wrapped in GestureDetector to open the file.
                      attachments != null && attachments.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          if (attachmentUrl.isNotEmpty) {
                            _openAttachment(attachmentUrl);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 26.h,
                              width: 97.w,
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
                                      attachmentName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
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
                      )
                          : Container(),
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
