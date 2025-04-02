import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudPersonalchat extends StatefulWidget {
  final int conversationId; // This is used as the receiver_id

  const StudPersonalchat({Key? key, required this.conversationId})
      : super(key: key);

  @override
  State<StudPersonalchat> createState() => _StudPersonalchatState();
}

class _StudPersonalchatState extends State<StudPersonalchat> {
  List<ChatMessage> _messages = [];
  List<int> _sentMessageIds = [];
  String? accessLoginToken;
  bool isLoading = true;
  bool hasError = false;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Assume the current user id is 2; update this as needed.
  int currentUserId = 0; // Initially set to 0 but updated later

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await _loadSentMessageIds();
    await fetchConversation();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');

    log("Retrieved Token: $token");
    log("Retrieved User ID: $userId");

    setState(() {
      accessLoginToken = token;
      if (userId != null) {
        currentUserId = userId; // ✅ Update with actual user ID
      }
    });
  }

  Future<void> _saveSentMessageIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sentMessageIds', jsonEncode(_sentMessageIds));
    log("Saved sent message ids: $_sentMessageIds");
  }

  Future<void> _loadSentMessageIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonIds = prefs.getString('sentMessageIds');
    if (jsonIds != null) {
      List<dynamic> ids = jsonDecode(jsonIds);
      _sentMessageIds = ids.map((e) => e as int).toList();
      log("Loaded sent message ids: $_sentMessageIds");
    } else {
      log("No sent message ids found in storage.");
    }
  }

  Future<void> fetchConversation() async {
    try {
      final url =
          'https://admin.uthix.com/api/get-conversation/${widget.conversationId}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
        },
      );

      log("Conversation API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> messagesJson = data['messages'];

        setState(() {
          _messages = messagesJson.map((json) {
            ChatMessage msg = ChatMessage.fromJson(json);
            bool senderFlag = (msg.senderId == currentUserId);
            return msg.copyWith(isSender: senderFlag);
          }).toList();

          // ✅ Sort messages in ASCENDING order (oldest → newest)
          _messages.sort((a, b) => DateTime.parse(a.createdAt)
              .compareTo(DateTime.parse(b.createdAt)));

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load conversation');
      }
    } catch (e) {
      log("Error fetching conversation: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> sendMessageToApi(String text) async {
    final url = 'https://admin.uthix.com/api/send-message';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'sender_id': currentUserId, // ✅ Correct sender ID
          'receiver_id': widget.conversationId.toString(),
          'message': text,
          'type': 'text',
        }),
      );
      log("Send Message Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messageData = data['data'];

        ChatMessage newMessage = ChatMessage(
          id: messageData['id'],
          senderId: currentUserId,
          receiverId: int.parse(messageData['receiver_id'].toString()),
          message: messageData['message'],
          isRead: messageData['is_read'] ? 1 : 0,
          createdAt: messageData['created_at'],
          receiverName: '',
          isSender: true,
        );

        _sentMessageIds.add(newMessage.id);
        log("Sent message id added: ${newMessage.id} | _sentMessageIds: $_sentMessageIds");
        await _saveSentMessageIds();

        setState(() {
          _messages.insert(0, newMessage);
        });
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      log("Error sending message: $e");
    }
  }

  void _sendMessage() async {
    final String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _messageController.clear();
      _focusNode.unfocus();
      await sendMessageToApi(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
            child: SizedBox(
              height: 85,
              child: Column(
                children: [
                  Row(
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
                      const SizedBox(width: 15),
                      Text(
                        "Ravi Pradhan",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(43, 92, 116, 1),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 14,
                        width: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(120, 170, 23, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Chat",
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(43, 92, 116, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromRGBO(200, 209, 215, 1),
          ),
          // Chat Message List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(child: Text("Failed to load conversation"))
                    : ListView.builder(
                        reverse: false, // Latest messages at bottom
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(message: _messages[index]);
                        },
                      ),
          ),
          // Bottom Input Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                // Icons container
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: IconButton(
                        icon: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color.fromRGBO(51, 152, 247, 1),
                                Color.fromRGBO(43, 92, 116, 1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: const Icon(Icons.add, size: 25),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: IconButton(
                        icon: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color.fromRGBO(51, 152, 247, 1),
                                Color.fromRGBO(43, 92, 116, 1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: const Icon(Icons.mic, size: 25),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: GoogleFonts.urbanist(
                          fontSize: 16, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(246, 246, 246, 1),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(51, 152, 247, 1),
                          Color.fromRGBO(43, 92, 116, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for a chat message fetched from conversation API.
class ChatMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final int isRead;
  final String createdAt;
  final String receiverName;
  final bool isSender;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.receiverName,
    required this.isSender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      receiverName: json['receiver']['name'],
      isSender: false, // default, will be updated later.
    );
  }

  ChatMessage copyWith({bool? isSender}) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      isRead: isRead,
      createdAt: createdAt,
      receiverName: receiverName,
      isSender: isSender ?? this.isSender,
    );
  }
}

// Message bubble widget to display a single chat message.
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = message.isSender;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) // Show profile image only for received messages
            ClipOval(
              child: Image.asset(
                'assets/login/profile.jpeg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isSender)
                    Text(
                      message.receiverName.isNotEmpty
                          ? message.receiverName
                          : "Unknown",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  if (!isSender) const SizedBox(width: 5),
                  Text(
                    message.createdAt.contains('T')
                        ? message.createdAt.split('T')[0]
                        : message.createdAt,
                    style:
                        GoogleFonts.urbanist(fontSize: 10, color: Colors.grey),
                  ),
                  if (isSender) const SizedBox(width: 5),
                  if (isSender)
                    Text(
                      'You',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: isSender
                      ? Colors.white
                      : const Color.fromRGBO(132, 162, 51, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  message.message,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: isSender ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
