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
import 'package:uthix_app/modal/nav_items.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/new_chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/personal_chat.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int selectedIndex = 2;
  String? accessLoginToken;
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

  int currentUserId = 0;

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('auth_token'); // Retrieve token
    int? userId = prefs.getInt('user_id'); // Retrieve user_id

    log("🔹 Retrieved Token: $token");
    log("🔹 Retrieved User ID: $userId");

    setState(() {
      accessLoginToken = token;
      currentUserId = userId ?? 0; // ✅ Ensure non-null user ID
    });
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

        // Group messages by the other participant (sender OR receiver)
        Map<int, dynamic> groupedMessages = {};

        for (var message in rawMessages) {
          int senderId = message['sender']['id'];
          int receiverId = message['receiver']['id'];

          // Determine the other participant (who you're chatting with)
          int otherUserId = senderId == currentUserId ? receiverId : senderId;

          // Get the existing message for the user
          var existingMessage = groupedMessages[otherUserId];

          // If there's no existing message or this one is newer, update it
          if (existingMessage == null ||
              DateTime.parse(message['created_at'])
                  .isAfter(DateTime.parse(existingMessage['created_at']))) {
            groupedMessages[otherUserId] = message;
          }
        }

        setState(() {
          messages = groupedMessages.values
              .toList(); // Ensure latest messages are displayed first
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

    if (index != 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 2;
        });
      });
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
                onPressed: () {
                  Navigator.pop(context);
                },
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
                    // <-- Added to take remaining space
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderId = message['sender']['id'];
                        final receiverId = message['receiver']['id'];

                        // Determine the chat partner (not the current user)
                        final otherUser = senderId == currentUserId
                            ? message['receiver']
                            : message['sender'];
                        final otherUserName = otherUser['name'] ?? "Unknown";
                        final messageText = message['message'] ??
                            "No message"; // Fallback if message is empty
                        final createdAt = message['created_at'] ?? "";
                        final formattedDate = createdAt.contains('T')
                            ? createdAt.split('T')[0]
                            : createdAt;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Personalchat(
                                    conversationId: otherUser['id']),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/login/profile.jpeg",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.person,
                                                    size: 50,
                                                    color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              otherUserName, // Show the actual chat partner's name
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              messageText,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  child: Navbar(
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
                      MaterialPageRoute(builder: (context) => NewChat()),
                    );
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(43, 92, 116, 1),
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.chat_bubble, size: 30, color: Colors.white),
                        Center(
                          child: Icon(Icons.add,
                              size: 20, color: Color.fromRGBO(43, 92, 116, 1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
