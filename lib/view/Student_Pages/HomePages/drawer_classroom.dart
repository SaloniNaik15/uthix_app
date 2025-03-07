import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Student_Pages/Attendance/attendance.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Calendar/calendar.dart';
import 'package:uthix_app/view/Student_Pages/Grade/grade.dart';
import 'package:uthix_app/view/Student_Pages/LMS/yourc_clasroom.dart';
import 'package:uthix_app/view/Student_Pages/Progress/progress_tracking.dart';

// Import all the pages

class MyDrawer extends StatefulWidget {
  const MyDrawer(
      {Key? key,
      required void Function(int index) onItemSelected,
      required int selectedIndex,
      required int initialIndex})
      : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int selectedIndex = 0; // Keep track of selected index

  final List<String> _titles = [
    "My Classes",
    "Calendar",
    "Progress Tracking",
    "My Orders",
    "Offline Files",
    "Recordings",
    "Buy Items",
    "Attendance",
    "My Grades",
    "My Account",
    "Help"
  ];

  final List<String> _iconPaths = [
    "assets/classroom_icons/home.png",
    "assets/classroom_icons/calendar.png",
    "assets/classroom_icons/track.png",
    "assets/classroom_icons/order.png",
    "assets/classroom_icons/offline_files.png",
    "assets/classroom_icons/record.png",
    "assets/classroom_icons/buy_items.png",
    "assets/classroom_icons/attendance.png",
    "assets/classroom_icons/grade.png",
    "assets/classroom_icons/my_account.png",
    "assets/classroom_icons/help.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios),
                    const SizedBox(width: 15),
                    Text(
                      "Your Classroom",
                      style: GoogleFonts.urbanist(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                if (index == 3) {
                  return Column(
                    children: [
                      Divider(
                        thickness: 2,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      _buildListTile(index),
                    ],
                  );
                }
                return _buildListTile(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(int index) {
    return ListTile(
      leading: Image.asset(
        _iconPaths[index],
        height: 30,
        width: 30,
        color: selectedIndex == index
            ? Colors.white
            : Color.fromRGBO(96, 95, 95, 1),
      ),
      title: Text(
        _titles[index],
        style: GoogleFonts.urbanist(
          fontSize: 18,
          color: selectedIndex == index
              ? Colors.white
              : Color.fromRGBO(96, 95, 95, 1),
        ),
      ),
      tileColor: selectedIndex == index
          ? Color.fromRGBO(43, 92, 116, 1)
          : Colors.white,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Close drawer before navigating
        Navigator.pop(context);

        // Navigate to the respective page
        _navigateToPage(index);
      },
    );
  }

  void _navigateToPage(int index) {
    Widget? page;

    switch (index) {
      case 0:
        page = YourClasroom();
        break;
      case 1:
        page = StudCalender();
        break;
      case 2:
        page = ProgressTracking();
        break;
      case 3:
        page = null;
        break;
      case 4:
        page = null;
        break;
      case 5:
        page = null;
        break;
      case 6:
        page = BuyTextBooks();
        break;
      case 7:
        page = Attendance();
        break;
      case 8:
        page = GradeStudent();
        break;
      case 9:
        page = null;
        break;
      case 10:
        page = null;
        break;
      default:
        return;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }
}
