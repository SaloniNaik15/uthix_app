import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';

import '../Buy_Books/Coupons.dart';
import '../Buy_Books/Wishlist.dart';
import 'Order_Tracking.dart';
import 'Student_Address.dart';
import 'Student_FAQ.dart';
import 'Student_ManageAccount.dart';
import 'Student_Order_HelpDesk.dart';
import 'Student_Profile.dart';
import 'Student_Settings.dart';
import 'Student_Wallet.dart';

class StudentAccountPages extends StatefulWidget {
  const StudentAccountPages({super.key});

  @override
  State<StudentAccountPages> createState() => _StudentAccountPagesState();
}

class _StudentAccountPagesState extends State<StudentAccountPages> {
  int selectedIndex = 4;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 4;
        });
      });
    }
  }

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_outlined, "title": "Home", "page": HomePages()},
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": StudFiles()},
    {"icon": Icons.find_in_page, "title": "Find", "page": BuyTextBooks()},
    {"icon": Icons.chat_outlined, "title": "Chat", "page": StudChat()},
    {
      "icon": Icons.person_outline,
      "title": "Profile",
      "page": StudentAccountPages()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 100), // Creates space before navbar
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Your Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 130,
                    width: 420,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 243, 255, 1),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Mahima",
                                style: GoogleFonts.urbanist(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "Congratulations! You are our premium member now",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 289,
                          child: Transform.rotate(
                            angle: -1.12 * (3.14159 / 180),
                            child: Opacity(
                              opacity: 1,
                              child: Image.asset(
                                'assets/instructor/premium.png',
                                width: 128,
                                height: 128,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFD9D9D9), width: 1),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3.5,
                            children: [
                              _buildGridItem(Icons.inventory_2_outlined,
                                  "Orders", context, OrdersTrackingPage()),
                              _buildGridItem(Icons.local_offer_outlined,
                                  "Coupons", context, CouponsScreen()),
                              _buildGridItem(Icons.favorite_border, "Wishlist",
                                  context, Wishlist()),
                              _buildGridItem(Icons.person_outline, "Profile",
                                  context, StudentProfile()),
                            ],
                          ),
                          SizedBox(height: 10),
                          const Divider(height: 1),
                          Column(
                            children: [
                              _buildListTile(
                                icon: Icons.headset_mic_outlined,
                                title: "Help Desk",
                                subtitle: "Connect with us",
                                navigateTo: StudentOrderHelpdesk(),
                                context: context,
                              ),
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.wallet_outlined,
                                title: "Wallet",
                                subtitle:
                                    "Wallet money & saved payment methods",
                                navigateTo: StudentWallet(),
                                context: context,
                              ),
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.location_on_outlined,
                                title: "My Addresses",
                                subtitle: "Add or edit your addresses",
                                navigateTo: StudentAddress(),
                                context: context,
                              ),
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.manage_accounts_outlined,
                                title: "Manage Accounts",
                                subtitle: "Your account and saved addresses",
                                navigateTo: StudentManageAccount(),
                                context: context,
                              ),
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.help_outline,
                                title: "FAQs",
                                subtitle: "Frequently Asked Questions",
                                navigateTo: StudentFaq(),
                                context: context,
                              ),
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.settings_outlined,
                                title: "Settings",
                                subtitle: "Get notifications",
                                navigateTo: StudentSettings(),
                                context: context,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          print("Outlined Button Pressed!");
                        },
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: "Urbanist",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom Bottom Navigation Bar (Always Above Background)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: NavbarStudent(
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget navigateTo,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigateTo));
      },
    );
  }

  Widget _buildGridItem(
      IconData icon, String title, BuildContext context, Widget navigateTo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Center(
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title),
        ),
      ),
    );
  }
}
