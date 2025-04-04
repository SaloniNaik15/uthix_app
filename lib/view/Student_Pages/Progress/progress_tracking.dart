import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  String? accessLoginToken;
  String? userName;
  String? profileImageUrl;
  ImageProvider _getProfileImage() {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {

      if (profileImageUrl!.startsWith("http")) {
        return NetworkImage(profileImageUrl!);
      } else {
        return FileImage(File(profileImageUrl!));
      }
    } else {
      return const AssetImage('assets/login/profile.png');
    }
  }
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessLoginToken = prefs.getString('auth_token');

    String? storedImage = prefs.getString('student_profile_image_url');
    if (storedImage != null && !storedImage.startsWith("http")) {
      profileImageUrl = "https://admin.uthix.com/storage/images/student/$storedImage";
    } else {
      profileImageUrl = storedImage;
    }

    log("Retrieved Token: $accessLoginToken");
    log("Final Resolved Image URL: $profileImageUrl");

    await _loadProfileFromCache();
    await _fetchUserProfile();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedProfile = prefs.getString("cached_profile");
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
      final response = await dio.get(
        "https://admin.uthix.com/api/profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String? imageFileName = data["image"];
        String? fullImageUrl = (imageFileName != null && imageFileName.isNotEmpty)
            ? "https://admin.uthix.com/storage/images/student/$imageFileName"
            : null;

        setState(() {
          userName = data["name"];
          profileImageUrl = fullImageUrl;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_profile", jsonEncode(data));
        prefs.setString("student_profile_image_url", imageFileName ?? "");

        log("Profile updated from API and cached.");
      } else {
        log("Failed to fetch user profile: ${response.statusMessage}");
      }
    } catch (e) {
      log("Error fetching user profile: $e");
    }
  }

  Widget buildInfoContainer(String title, String value) {
    return Container(
      height: 102,
      width: 102,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryContainer(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(96, 95, 95, 1),
        ),
      ),
    );
  }

  Widget buildLegend(String text) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(96, 95, 95, 1),
          ),
        ),
      ],
    );
  }

  Widget buildBarChart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 100,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
              AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    List<String> labels = [
                      "Jan XX",
                      "Jan YY",
                      "Feb XX",
                      "Feb YY",
                      "Mar XX",
                      "Mar YY",
                      "Apr XX",
                      "Apr YY",
                      "May XX",
                      "May YY",
                      "Jun XX"
                    ];

                    return (value.toInt() < 0 || value.toInt() >= labels.length)
                        ? Container()
                        : Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        labels[value.toInt()],
                        style: GoogleFonts.urbanist(
                            fontSize: 8, fontWeight: FontWeight.w700),
                      ),
                    );
                  },
                  reservedSize: 50.h,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }

  Widget buildStatisticsContainer() {
    return Container(
      height: 310.h,
      width: 340.w,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildCategoryContainer("Upcoming Exams"),
              buildCategoryContainer("Track Scores"),
            ],
          ),
          const SizedBox(height: 20),
          buildBarChart(),
          const Divider(
            thickness: 1,
            color: Color.fromRGBO(217, 217, 217, 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLegend("XX-YEAR 1"),
                buildLegend("XX-YEAR 1"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(11, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 7.0,
            width: 20,
            borderRadius: BorderRadius.zero,
            color: Colors.blue,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    )
        : Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
              backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "My Progress",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  userName ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(43, 92, 116, 1),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildInfoContainer("Last Grade", "70%"),
                      buildInfoContainer("Assignment", "5/8"),
                      buildInfoContainer("Attendance", "77%"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My Performance Chart",
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildStatisticsContainer(),
              ],
            ),
          ),
        ),
        Positioned(
          top: 80,
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
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage('assets/login/profile.png') as ImageProvider,
                onBackgroundImageError: (_, __) {
                  debugPrint("❌ Error loading profile image");
                },
              )
            ),
          ),
        ),
      ],
    );
  }
}