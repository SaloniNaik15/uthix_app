import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BuyPlans extends StatefulWidget {
  const BuyPlans({super.key});

  @override
  State<BuyPlans> createState() => _BuyPlansState();
}

class _BuyPlansState extends State<BuyPlans> {
  List<Map<String, dynamic>> plans = [];
  final List<Map<String, String>> features = [
    {
      "icon": "assets/buyplan/refund.png",
      "text":
          "No Refunds: All purchases are final. Please choose your plan carefully."
    },
    {
      "icon": "assets/buyplan/tick.png",
      "text":
          "7-Day Free Trial: Upgrade or cancel anytime before the trial ends."
    },
    {
      "icon": "assets/buyplan/lock.png",
      "text":
          "Secure Your Learning: Once enrolled, access cannot be transferred or refunded."
    },
    {
      "icon": "assets/buyplan/speaker.png",
      "text":
          "Upgrade Anytime: You can switch to a higher plan anytime for more benefits."
    },
  ];
  bool isLoading = true;
  String? accessLoginToken;

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
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    final Dio dio = Dio();
    const String apiUrl = "https://admin.uthix.com/api/plans/student";
    String? token = accessLoginToken;

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      log("API Response: ${response.data}"); // Debugging

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data']['plans'] != null) {
          setState(() {
            plans = List<Map<String, dynamic>>.from(data['data']['plans']);
            isLoading = false;
          });
        } else {
          print("No plans found in response");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching plans: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildbenefits(String imagePath, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Image.asset(imagePath, width: 24.w, height: 24.h),
          ),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: "Urbanist",
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    List<String> features = [];

    try {
      features = List<String>.from(jsonDecode(plan["features"]));
    } catch (e) {
      print("Error parsing features: $e");
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan["name"],
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  Text(plan["description"],
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Rs. ${plan["price"]}",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  Text("/${plan["duration"]}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Features List
          ...features.map((feature) => _buildFeatureRow(feature)).toList(),
          SizedBox(height: 20.h),
          // Select Plan Button
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                // Handle Plan Selection
              },
              child: Text(
                "Select ${plan["name"]} Plan",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Choose Your Plan",
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            // Hardcoded Texts Above ListView
            ...features
                .map((feature) =>
                    _buildbenefits(feature['icon']!, feature['text']!))
                .toList(),
            SizedBox(
              height: 20.h,
            ),
            // API Data or Loading Indicator
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : plans.isEmpty
                      ? Center(child: Text("No plans available"))
                      : ListView(
                          children: plans
                              .map((plan) => _buildPlanCard(plan))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
