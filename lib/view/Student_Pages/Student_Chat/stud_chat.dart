// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_newChart.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_personalChat.dart';

class StudChat extends StatefulWidget {
  const StudChat({super.key});

  @override
  State<StudChat> createState() => _StudChatState();
}

class _StudChatState extends State<StudChat> {
  int selectedIndex = 3;
  String? accessLoginToken;
  String? profileImageUrl;
  int currentUserId = 0;
  List<dynamic> messages = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchMessages();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    String? imageFromPrefs = prefs.getString('student_profile_image_url');

    // Convert filename to full URL if needed
    String? imageUrl = (imageFromPrefs != null && !imageFromPrefs.startsWith("http"))
        ? "https://admin.uthix.com/storage/images/student/$imageFromPrefs"
        : imageFromPrefs;

    setState(() {
      accessLoginToken = token;
      currentUserId = userId ?? 0;
      profileImageUrl = imageUrl;
    });

    log("Retrieved Token: $token");
    log("CHAT-STUDENT Retrieved User ID: $userId");
    log("Final Resolved Profile Image URL: $profileImageUrl");
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse('https://admin.uthix.com/api/get-messages'),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
        },
      );
      log("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> rawMessages = data['messages'];

        Map<int, dynamic> groupedMessages = {};
        for (var message in rawMessages) {
          int senderId = message['sender']['id'];
          int receiverId = message['receiver']['id'];
          int otherUserId = senderId == currentUserId ? receiverId : senderId;

          var existingMessage = groupedMessages[otherUserId];
          if (existingMessage == null ||
              DateTime.parse(message['created_at']).isAfter(DateTime.parse(existingMessage['created_at']))) {
            groupedMessages[otherUserId] = message;
          }
        }

        setState(() {
          messages = groupedMessages.values.toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      log("Error fetching messages: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) => setState(() => selectedIndex = 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.h),
            child: AppBar(
              backgroundColor: const Color(0xFF2B5C74),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Chat",
                style: GoogleFonts.urbanist(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderId = message['sender']['id'];
                        final receiverId = message['receiver']['id'];
                        final otherUser = senderId == currentUserId
                            ? message['receiver']
                            : message['sender'];

                        final otherUserName = otherUser['name'] ?? "Unknown";
                        final messageText = message['message'] ?? "No message";
                        final createdAt = message['created_at'] ?? "";
                        final formattedDate = createdAt.contains('T')
                            ? createdAt.split('T')[0]
                            : createdAt;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudPersonalchat(conversationId: otherUser['id']),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/login/profile.png"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              otherUserName,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        messageText,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: NavbarStudent(
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StudNewchart()),
                    );
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B5C74),
                      borderRadius: BorderRadius.circular(32),
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
                    child: const Icon(Icons.chat_bubble, size: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 100,
          left: (MediaQuery.of(context).size.width - 80) / 2,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(51, 152, 246, 0.75),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage('assets/login/profile.png') as ImageProvider,
                onBackgroundImageError: (_, __) {
                  debugPrint("❌ Error loading profile image from cache");
                },
              ),
            ),
          ),
        ),

      ],
    );
  }
}