import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({super.key});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final List<Message> _messages = [
    // Sample messages for demonstration
    Message(text: "Hello!", isSender: false, time: "10:00 AM"),
    Message(text: "Hi there!", isSender: true, time: "10:01 AM"),
  ];

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _sendMessage() {
    final String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        // Insert at the beginning because ListView is reversed.
        _messages.insert(0, Message(text: text, isSender: true, time: "Now"));
      });
      _messageController.clear();
      _focusNode.unfocus();
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
              height: 80,
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
            thickness: 3,
            color: Color.fromRGBO(200, 209, 215, 1),
          ),
          // Chat Message List
          Expanded(
            child: ListView.builder(
              reverse: true, // Latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          // Bottom Input Container: Icons at left and TextField at right
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                // Icons container
                Container(
                  child: Row(
                    children: [
                      // "Add" icon inside a circular container.
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
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
                          onPressed: () {
                            // Add functionality for the add button here.
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
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
                          onPressed: () {
                            // Add functionality for the add button here.
                          },
                        ),
                      ),
                    ],
                  ),
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
                // Send button
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

class Message {
  final String text;
  final bool isSender;
  final String time;

  Message({required this.text, required this.isSender, required this.time});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender)
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
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!message.isSender)
                    Text(
                      'Ravi Pradhan',
                      style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  if (!message.isSender) const SizedBox(width: 5),
                  Text(
                    message.time,
                    style:
                        GoogleFonts.urbanist(fontSize: 10, color: Colors.grey),
                  ),
                  if (message.isSender) const SizedBox(width: 5),
                  if (message.isSender)
                    Text(
                      'You',
                      style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: message.isSender
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(43, 92, 116, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: message.isSender ? Colors.black : Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
