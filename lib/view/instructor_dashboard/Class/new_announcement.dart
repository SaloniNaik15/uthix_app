import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({super.key});

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final TextEditingController _announceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    final announcementText = _announceController.text.trim();
                    if (announcementText.isNotEmpty) {
                      Provider.of<AnnouncementProvider>(context, listen: false)
                          .updateAnnouncement(announcementText);
                      Navigator.pop(context, announcementText);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(43, 92, 116, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Post",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            Row(
              children: [
                const Icon(Icons.menu, color: Color.fromRGBO(43, 92, 116, 1)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _announceController,
                    style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Announce something to your class",
                      hintStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            Row(
              children: [
                const Icon(Icons.link, color: Color.fromRGBO(43, 92, 116, 1)),
                const SizedBox(width: 10),
                Text(
                  "Add Attachement",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 45),
              ],
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            Row(
              children: [
                const Icon(Icons.alarm, color: Color.fromRGBO(43, 92, 116, 1)),
                const SizedBox(width: 10),
                Text(
                  "Due Date",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 45),
              ],
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
