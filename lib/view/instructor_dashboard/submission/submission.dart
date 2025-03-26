import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/view_assignmnets.dart';
import 'package:url_launcher/url_launcher.dart';

class Submission extends StatefulWidget {
  const Submission({Key? key}) : super(key: key);

  @override
  State<Submission> createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  String? token;
  bool isLoading = true;
  Map<String, dynamic>? assignment;

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
      _fetchSubmission();
    } else {
      print("No token found. User may not be logged in.");
    }
  }

  Future<void> _fetchSubmission() async {
    try {
      final response = await Dio().get(
        'https://admin.uthix.com/api/assignments/1/submissions',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          assignment = response.data["assignment"];
          isLoading = false;
        });
      } else {
        print("Error: Invalid submission response");
      }
    } catch (e) {
      print("Error fetching submission: $e");
    }
  }

  // Function to open the attachment URL
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
      // AppBar with dynamic sizing and iOS-style back arrow.
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main assignment details container.
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(7.r),
                    border: Border.all(
                      color: const Color.fromRGBO(217, 217, 217, 1),
                      width: 1.w,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.h, left: 30.w, right: 30.w, bottom: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(96, 95, 95, 1),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Due: 20 Jan 2025",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(96, 95, 95, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          assignment?["title"] ??
                              "Submit your Report here",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text(
                              "Comments: 6",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color:
                                const Color.fromRGBO(142, 140, 140, 1),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${assignment?["total_submissions"] ?? 0} out of 30 Submissions",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color:
                                const Color.fromRGBO(142, 140, 140, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAssignmnets(),
                              ),
                            );
                          },
                          child: Container(
                            height: 27.h,
                            width: 148.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: const Color.fromRGBO(43, 92, 116, 1),
                            ),
                            child: Center(
                              child: Text(
                                "View Submission",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20.w,
                  bottom: -8.h,
                  child: Container(
                    width: 35.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                            "assets/instructor/emoticon-happy-outline.png"),
                        Icon(Icons.add, size: 10.sp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // "Comment" header text.
            Padding(
              padding: EdgeInsets.only(right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Comment",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // List of submission uploads (comments)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignment?["uploads"]?.length ?? 0,
                itemBuilder: (context, index) {
                  final upload = assignment?["uploads"][index];
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: upload["student"]["profile_image"] !=
                                      null
                                      ? Image.network(
                                    upload["student"]
                                    ["profile_image"],
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    "assets/login/profile.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        upload["student"]["name"] ??
                                            "No Name",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        upload["submitted_at"] ?? "",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              96, 95, 95, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    upload["comment"] ?? "",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Display attachments if available.
                                  upload["attachments"] != null &&
                                      upload["attachments"].length > 0
                                      ? Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: List.generate(
                                      upload["attachments"].length,
                                          (attIndex) {
                                        final attachment =
                                        upload["attachments"]
                                        [attIndex];
                                        final attachmentUrl =
                                            "https://admin.uthix.com/uploads/${attachment['file_path']}";
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h),
                                          child: GestureDetector(
                                            onTap: () {
                                              _openAttachment(
                                                  attachmentUrl);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.attach_file,
                                                    color: Colors.grey,
                                                    size: 14.sp),
                                                SizedBox(width: 5.w),
                                                Expanded(
                                                  child: Text(
                                                    attachment[
                                                    "file_path"],
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
