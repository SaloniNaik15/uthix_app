import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modal/Snackbar.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  int selectedTab = 0;
  List<String> tabs = ["Trending", "Discount", "Expiring"];
  List<dynamic> coupons = [];
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize data by loading the auth token and any cached coupons,
  /// then fetch new coupons from the API.
  Future<void> _initializeData() async {
    await loadAuthToken();
    await _loadCouponsFromCache();
    fetchCoupons();
  }

  /// Load the auth token from SharedPreferences
  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    setState(() {
      _authToken = token;
    });
  }

  /// Attempt to load cached coupons from SharedPreferences
  Future<void> _loadCouponsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedCoupons = prefs.getString('cached_coupons');
    if (cachedCoupons != null) {
      try {
        final List<dynamic> data = jsonDecode(cachedCoupons);
        setState(() {
          coupons = data;
        });
        log("Loaded coupons from cache.");
      } catch (e) {
        log("Error decoding cached coupons: $e");
      }
    }
  }

  /// Fetch coupons from the API, then cache them if successful
  Future<void> fetchCoupons() async {
    const String apiUrl = "https://admin.uthix.com/api/manage-coupon";
    if (_authToken == null || _authToken!.isEmpty) {
      print("Auth token is missing");
      return;
    }
    try {
      final response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {"Authorization": "Bearer $_authToken"},
        ),
      );

      print("Coupons API Response: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final newCoupons = response.data['coupons'];
        setState(() {
          coupons = newCoupons;
        });

        // Cache the coupons in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_coupons", jsonEncode(newCoupons));

      } else {
        print("Failed to fetch coupons: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching coupons: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              child: Text(
                "Coupons",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: -10,
              child: Image.asset(
                'assets/Student_Home_icons/student_cupon.png',
                width: 90.w,
                height: 90.h,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 2),
        color: const Color(0xFFEFEFEF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(tabs.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTab == index
                              ? const Color(0xFF2B5C74)
                              : Colors.transparent,
                          border: Border.all(
                            color: selectedTab == index
                                ? const Color(0xFF2B5C74)
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectedTab == index
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return CouponCard(coupon: coupons[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final Map<String, dynamic> coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  "assets/Student_Home_icons/couponBook.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 10),
               DottedDividerWithIcon(
                height: 30,

                color: Colors.grey,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${coupon["discount_value"]}% off ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Text(
                          "Code: ${coupon["code"]} ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await Clipboard.setData(ClipboardData(text: coupon["code"] ?? ""));
                              SnackbarHelper.showMessage(
                                context,
                                message: "Coupon code copied to clipboard!",
                                backgroundColor: const Color(0xFF2B5C74),
                              );
                            } catch (e) {
                              SnackbarHelper.showMessage(
                                context,
                                message: "Error copying coupon code.",
                                backgroundColor: Colors.redAccent,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.copy,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Expiry: ${coupon["expiration_date"]}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 5.h),
                    // TextButton(
                    //   onPressed: () {},
                    //   style: TextButton.styleFrom(
                    //     padding: EdgeInsets.zero,
                    //     minimumSize: Size(0, 30.h),
                    //   ),
                    //   child: Text(
                    //     "View Products",
                    //     style: TextStyle(
                    //       fontSize: 16.sp,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedDividerWithIcon extends StatelessWidget {
  final double height;
  final Color color;
  final IconData icon;

  const DottedDividerWithIcon({
    super.key,
    this.height = 50,
    this.color = Colors.grey,
    this.icon = Icons.content_cut, // Material scissors icon
  });

  @override
  Widget build(BuildContext context) {
    int dotCount = (height ~/ 2.5);
    int half = dotCount ~/ 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < half; i++)
          Container(
            width: 2,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 1),
            color: color,
          ),
        Transform.rotate(
          angle: 1.55, // Rotate 180 degrees (π radians)
          child: Icon(icon, size: 18, color: color),
        ),
        for (int i = 0; i < half; i++)
          Container(
            width: 2,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 1),
            color: color,
          ),
      ],
    );
  }
}
