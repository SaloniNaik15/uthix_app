import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({Key? key}) : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  /// Example messages. Replace with your own data or fetch from API/db.
  final List<Message> _messages = [
    Message(
      text: "Hi. What can I help you with?",
      isSender: false,
      time: "08:23 PM",
    ),
    Message(
      text:
      "Well, I noticed that you have a collection of competitive exam books and I would like to meet you in person and discuss exchange of books!",
      isSender: true,
      time: "08:32 PM",
    ),
    Message(
      text:
      "Indeed. I just saw that we are from the same Uni. How about meeting up at the cafeteria tomorrow?",
      isSender: false,
      time: "08:32 PM",
    ),
  ];

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _sendMessage() {
    final String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        // Insert new message at the "bottom" of the list, so it appears last.
        // Because the ListView is reversed, we actually insert at index 0.
        _messages.insert(
          0,
          Message(
            text: text,
            isSender: true,
            time: "Now",
          ),
        );
      });
      _messageController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matches background from your design
      backgroundColor: const Color(0xFFF3F4F6),

      // ------------------- AppBar -------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              "Ravi Pradhan",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(43, 92, 116, 1),
              ),
            ),
            SizedBox(width: 5.w),
            // Small green circle to show "online"
            Container(
              height: 8.h,
              width: 8.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(120, 170, 23, 1),
              ),
            ),
          ],
        ),
      ),

      // ------------------- Body -------------------
      body: Column(
        children: [
          // -------- Messages List --------
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),

          // -------- Bottom Input Bar --------
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                // Left icons (Add, Mic)
                Row(
                  children: [
                    // "Add" icon
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.w,
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
                          child: Icon(Icons.add, size: 22.sp),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 0.w,
                          minHeight: 0.h,
                        ),
                        onPressed: () {
                          // TODO: Handle "Add" action
                        },
                      ),
                    ),
                    SizedBox(width: 5.w),

                    // Mic icon
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.w,
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
                          child: Icon(Icons.mic, size: 22.sp),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 0.w,
                          minHeight: 0.h,
                        ),
                        onPressed: () {
                          // TODO: Handle "Mic" action
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 8.w),

                // Text Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(246, 246, 246, 1),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 12.h,
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),

                SizedBox(width: 10.w),

                // Send button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    height: 40.h,
                    width: 40.w,
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
                    padding: EdgeInsets.all(10.w),
                    child: Icon(Icons.send, color: Colors.white, size: 18.sp),
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

// ------------------- Model -------------------
class Message {
  final String text;
  final bool isSender;
  final String time;

  Message({
    required this.text,
    required this.isSender,
    required this.time,
  });
}

// ------------------- Message Bubble -------------------
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Row(
          mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender's avatar only on left side if not sender
            if (!isSender)
              ClipOval(
                child: Image.asset(
                  'assets/login/profile.jpeg', // or a network image
                  height: 40.h,
                  width: 40.h,
                  fit: BoxFit.cover,
                ),
              ),
            if (!isSender) SizedBox(width: 8.w),

            // Column for name/time and bubble
            Column(
              crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Name + time
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isSender)
                      Text(
                        'Ravi Pradhan',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    if (!isSender) SizedBox(width: 5.w),
                    Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey,
                      ),
                    ),
                    if (isSender) SizedBox(width: 5.w),
                    if (isSender)
                      Text(
                        'You',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Actual message bubble
                Container(
                  // The message bubble won’t exceed 60% of screen width
                  constraints: BoxConstraints(maxWidth: 0.6.sw),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 15.w,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isSender
                        ? const Color.fromRGBO(255, 255, 255, 1)
                        : const Color.fromRGBO(43, 92, 116, 1),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSender ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
