import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/grade.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAssignmnets extends StatefulWidget {
  const ViewAssignmnets({super.key});

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            children: [
              Text(
                "All Submissions",
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              Text(
                "Total $totalSubmissions out of 30",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: Expanded(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
                    // Use the first attachment if available.
                    final attachments = upload["attachments"] as List<dynamic>?;
                    final attachmentName =
                        (attachments != null && attachments.isNotEmpty)
                            ? attachments[0]["file_name"] ?? ""
                            : "No attachment";
                    // Construct the attachment URL.
                    final attachmentUrl = (attachments != null &&
                            attachments.isNotEmpty)
                        ? "https://admin.uthix.com/uploads/${attachments[0]['file_path']}"
                        : "";
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        height: 203,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(217, 217, 217, 1),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row: profile image, name, submission date, Grade button
                              Row(
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
                                        child:
                                            (student["profile_image"] != null)
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
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        studentName,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        submittedAt,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: const Color.fromRGBO(
                                              96, 95, 95, 1),
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
                                              builder: (context) =>
                                                  const Grade()));
                                    },
                                    child: Container(
                                      height: 37,
                                      width: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color.fromRGBO(
                                            43, 92, 116, 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Grade",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16,
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
                              const SizedBox(height: 20),
                              // Submission details
                              Text(
                                "Name: $studentName",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Class: $classInfo",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                comment,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Attachment row wrapped in GestureDetector to open the file
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
                                            height: 26,
                                            width: 97,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    217, 217, 217, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Transform.rotate(
                                                  angle: 45 * 3.1415927 / 180,
                                                  child: Image.asset(
                                                    "assets/instructor/link.png",
                                                    scale: 2,
                                                    color: const Color.fromRGBO(
                                                        96, 95, 94, 1),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    attachmentName,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color:
                                                          const Color.fromRGBO(
                                                              96, 95, 95, 1),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
      ),
    );
  }
}
