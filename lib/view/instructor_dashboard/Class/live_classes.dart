import 'package:flutter/material.dart';

class LiveClasses extends StatelessWidget {
  const LiveClasses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 25,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Circle with a plus icon
          // Container(
          //   width: 40,
          //   height: 40,
          //   margin: const EdgeInsets.only(right: 15),
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: const Color.fromRGBO(43, 93, 116, 1),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.06),
          //         offset: const Offset(0, 2),
          //         blurRadius: 4,
          //       ),
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.04),
          //         offset: const Offset(0, 0),
          //         blurRadius: 6,
          //       ),
          //     ],
          //   ),
          //   child: const Icon(
          //     Icons.add,
          //     size: 35,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Teacher image (simulating a "live class" view)
            Container(
              width: double.infinity,
              height: 230,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color.fromRGBO(11, 159, 167, 1),
                  width: 1,
                ),
                image: const DecorationImage(
                  image: AssetImage("assets/teacher_sample.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              // You can place overlay icons or controls on the image if needed.
            ),

            // Spacing
            const SizedBox(height: 20),

            // Subject and Chapter details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PREVIOUS / ONGOING / NEXT row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabButton("PREVIOUS"),
                      _buildTabButton("ONGOING", isSelected: true),
                      _buildTabButton("NEXT"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Subject and chapter info
                  const Text(
                    "SUBJECT: Mathematics",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(16, 95, 131, 1),
                    ),
                  ),
                  const Text(
                    "CHAPTER: Algebra by Om Prakasah",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(132, 132, 132, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Example text: "You are 5th in the row"
                  const Text(
                    "You are 5th in the row",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(132, 132, 132, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Example message bubble for user queries
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(246, 246, 246, 1),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with user avatar + placeholder text
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
                        const Text(
                          "You can type your queries here!",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(
                      thickness: 1,
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    // "Send" button
                    Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(43, 92, 116, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Example chat/announcement messages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildChatBubble(
                    name: "Co Mentor",
                    time: "Just Now | 12 Aug 2025",
                    message: "New Assignment: Submit your report here",
                  ),
                  _buildChatBubble(
                    name: "Your new query",
                    time: "10:00 | 12 Aug 2025",
                    message:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ?",
                    isUser: true,
                  ),
                  _buildChatBubble(
                    name: "Co Mentor",
                    time: "1 hour ago | 12 Aug 2025",
                    message: "New Assignment: Submit your homework",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper for the PREVIOUS / ONGOING / NEXT row
  Widget _buildTabButton(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: isSelected
          ? BoxDecoration(
        color: const Color.fromRGBO(43, 92, 116, 1),
        borderRadius: BorderRadius.circular(4),
      )
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Helper for chat-like announcement bubbles
  Widget _buildChatBubble({
    required String name,
    required String time,
    required String message,
    bool isUser = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color.fromRGBO(217, 217, 217, 1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with avatar, name, time, and a 3-dot menu icon
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 8),
          // Message content
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          // "Add Comment" text
          const Text(
            "Add Comment",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(142, 140, 140, 1),
            ),
          ),
        ],
      ),
    );
  }
}
