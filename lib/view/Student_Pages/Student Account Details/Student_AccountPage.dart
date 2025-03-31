import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Ecommerce/e_commerce.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Logout.dart';
import '../../homeRegistration/registration.dart';
import '../BuyPlans/buyplans.dart';
import '../BuyPlans/viewsubscriptiondetails.dart';
import '../Buy_Books/Coupons.dart';
import '../Buy_Books/Wishlist.dart';
import 'Order_Tracking.dart';
import 'Student_Address.dart';
import 'Student_FAQ.dart';
import 'Student_HelpDesk.dart';
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
  String? accessLoginToken;
  String? userName;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });

    // Load cached profile first (if available)
    await _loadProfileFromCache();
    // Then fetch the latest profile from the API
    _fetchUserProfile();
  }

  Future<void> _loadProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedProfile = prefs.getString('cached_profile');
    if (cachedProfile != null) {
      try {
        final data = jsonDecode(cachedProfile);
        setState(() {
          userName = data["name"];
        });
        log("Loaded profile from cache.");
      } catch (e) {
        log("Error decoding cached profile: $e");
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final dio = Dio();
      // Replace with your actual API endpoint for fetching the user profile.
      final response = await dio.get(
        "https://admin.uthix.com/api/profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          userName = data["name"]; // For example: "kirti"
        });
        // Cache the profile data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_profile", jsonEncode(data));
        log("Profile updated from API and cached.");
      } else {
        log("Failed to fetch user profile: ${response.statusMessage}");
      }
    } catch (e) {
      log("Error fetching user profile: $e");
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 4;
        });
      });
    }
  }

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
            padding: const EdgeInsets.only(bottom: 85), // Space for navbar
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Your Profile",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> BuyPlans()));
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF2B5C74),
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            "Buy Plan",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 130,
                    width: 420,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(229, 243, 255, 1),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Use fetched userName; show fallback if null
                              Text(
                                userName ?? "...",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "Congratulations! You are our premium member now",
                                  style: TextStyle(
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFD9D9D9), width: 1),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3.5,
                            children: [
                              _buildGridItem(Icons.inventory_2_outlined,
                                  "Orders", context, UnderConstructionScreen()),
                              _buildGridItem(Icons.local_offer_outlined,
                                  "Coupons", context, CouponsScreen()),
                              _buildGridItem(Icons.favorite_border, "Wishlist",
                                  context, UnderConstructionScreen()),
                              _buildGridItem(Icons.person_outline, "Profile",
                                  context, StudentProfile()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1),
                          Column(
                            children: [
                              _buildListTile(
                                icon: Icons.headset_mic_outlined,
                                title: "Help Desk",
                                subtitle: "Connect with us",
                                navigateTo: StudentHelpdesk(),
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
                                navigateTo: UnderConstructionScreen(),
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
                              const Divider(height: 1),
                              _buildListTile(
                                icon: Icons.currency_exchange_outlined,
                                title: "Subscription Details",
                                subtitle: "You can see the plans details",
                                navigateTo: ViewSubscriptionDetails(),
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
                          logoutUser(context);
                        },
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom Bottom Navigation Bar
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
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
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
