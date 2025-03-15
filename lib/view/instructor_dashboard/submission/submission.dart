import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/view_assignmnets.dart';
import 'package:url_launcher/url_launcher.dart';

class Submission extends StatefulWidget {
  const Submission({super.key});

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top navigation bar with back button
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 20, right: 10),
                    child: Container(
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
                  ),
                  const SizedBox(height: 40),
                  // Assignment details container
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: const Color.fromRGBO(217, 217, 217, 1),
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 30, right: 30, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Date",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color.fromRGBO(96, 95, 95, 1),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Due: 20 Jan 2025",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color.fromRGBO(96, 95, 95, 1),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                assignment?["title"] ??
                                    "Submit your Report here",
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(96, 95, 95, 1),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "Comments: 6",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          142, 140, 140, 1),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${assignment?["total_submissions"] ?? 0} out of 30 Submissions",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          142, 140, 140, 1),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewAssignmnets()));
                                },
                                child: Container(
                                  height: 27,
                                  width: 148,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color.fromRGBO(43, 92, 116, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "View Submission",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
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
                        left: 20,
                        bottom: -8,
                        child: Container(
                          width: 35,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(246, 246, 246, 1),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  "assets/instructor/emoticon-happy-outline.png"),
                              const Icon(Icons.add, size: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // "Comment" header text
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Comment",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List of submission uploads (comments)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: assignment?["uploads"]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final upload = assignment?["uploads"][index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 39,
                                    height: 39,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: upload["student"]
                                                    ["profile_image"] !=
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
                                  const SizedBox(width: 15),
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
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              upload["submitted_at"] ?? "",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(
                                                    96, 95, 95, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          upload["comment"] ?? "",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // Display attachments if available
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _openAttachment(
                                                              attachmentUrl);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .attach_file,
                                                                color: Colors
                                                                    .grey),
                                                            const SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Text(
                                                                attachment[
                                                                    "file_path"],
                                                                style: GoogleFonts
                                                                    .urbanist(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
