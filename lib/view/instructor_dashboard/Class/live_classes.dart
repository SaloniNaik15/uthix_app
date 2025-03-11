// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';

class LiveClasses extends StatefulWidget {
  const LiveClasses({super.key});

  @override
  State<LiveClasses> createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  String? _startUrl;
  late Future<void> _initializeWebViewFuture;
  final Dio _dio = Dio();

  // Fetch the API response and extract the start_url from the JSON.
  Future<void> fetchStartUrl() async {
    try {
      // Replace with your actual API endpoint.
      final response =
          await _dio.get('https://admin.uthix.com/api/zoom/create-meeting');
      if (response.statusCode == 200) {
        setState(() {
          // You might consider using join_url if that is standard http/https.
          _startUrl = response.data['start_url'];
        });
      } else {
        throw Exception('Failed to load start URL');
      }
    } catch (e) {
      throw Exception('Error fetching start URL: $e');
    }
  }

  // Launch the URL externally using url_launcher.
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeWebViewFuture = fetchStartUrl();
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back button.
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Row(
                children: [
                  Container(
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
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Container to show the Zoom meeting using a WebViewWidget.
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color.fromRGBO(11, 159, 167, 1),
                  width: 1,
                ),
              ),
              child: FutureBuilder(
                future: _initializeWebViewFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_startUrl != null) {
                      // Create and configure the WebViewController.
                      final controller = WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onNavigationRequest: (NavigationRequest request) {
                              // If the URL scheme is not HTTP/HTTPS, launch externally.
                              if (!request.url.startsWith('http') &&
                                  !request.url.startsWith('https')) {
                                _launchURL(request.url);
                                return NavigationDecision.prevent;
                              }
                              return NavigationDecision.navigate;
                            },
                          ),
                        )
                        ..loadRequest(Uri.parse(_startUrl!));
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: WebViewWidget(controller: controller),
                      );
                    } else {
                      return const Center(child: Text("No URL found"));
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Additional content below the WebViewWidget.
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SUBJECT: Mathematics",
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(16, 95, 131, 1),
                    ),
                  ),
                  Text(
                    "CHAPTER: Algebra by Om Prakasah",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(132, 132, 132, 1),
                    ),
                  ),
                  Text(
                    "YOU HAVE 3 CO-MENTORS TO HELP YOU",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(132, 132, 132, 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 150,
                    width: 340,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/login/profile.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "You can type your queries here!",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Divider(
                            thickness: 1,
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(217, 217, 217, 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                "Send",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(43, 92, 116, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Announcements list.
                  Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: announcementProvider.announcements.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (announcementProvider.announcements[index]
                                .contains("Submit your report")) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Submission(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 340,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(246, 246, 246, 1),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Surayaiya Jagannath",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.more_vert),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    announcementProvider.announcements[index],
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Add Attachment",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          142, 140, 140, 1),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color:
                                        const Color.fromRGBO(213, 213, 213, 1),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  Text(
                                    "Add Comment",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          142, 140, 140, 1),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
