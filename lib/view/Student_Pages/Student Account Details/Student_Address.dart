import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../login/start_login.dart';
import '../../homeRegistration/new_login.dart';
import 'Student_Add_Address.dart';

class StudentAddress extends StatefulWidget {
  const StudentAddress({super.key, required Map<String, dynamic> address});

  @override
  State<StudentAddress> createState() => _StudentAddressState();
}

class _StudentAddressState extends State<StudentAddress> {
  int? selectedAddressIndex;
  List<Map<String, dynamic>> addresses = [];
  final Dio _dio = Dio();
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
    _fetchAddresses();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      _authToken = token;
    });
  }

  Future<void> _fetchAddresses() async {
    if (_authToken == null || _authToken!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Authentication failed. Please log in again."),
          duration: const Duration(seconds: 1),
          backgroundColor: Color(0xFF2B5C74),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      handle401Error();
      return;
    }

    try {
      final response = await _dio.get(
        "https://admin.uthix.com/api/address",
        options: Options(
          headers: {
            "Authorization": "Bearer $_authToken", // Dynamic Token
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.containsKey("address")) {
        setState(() {
          addresses = List<Map<String, dynamic>>.from(response.data["address"]);
        });
      } else if (response.statusCode == 401) {
        log("⛔ Unauthorized: Token is invalid or expired.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Session expired. Please log in again."),
            duration: const Duration(seconds: 1),
            backgroundColor: Color(0xFF2B5C74),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        handle401Error();
      } else {
        log("⛔ Failed to fetch addresses: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("❌ Error fetching addresses: ${response.data.toString()}"),
            duration: const Duration(seconds: 1),
            backgroundColor: Color(0xFF2B5C74),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      log("⛔ Error fetching addresses: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Network error. Please try again."),
          duration: const Duration(seconds: 1),
          backgroundColor: Color(0xFF2B5C74),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> handle401Error() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NewLogin()),
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
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: const Color(0xFF605F5F),
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              "My Addresses",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // "Add New Address" button
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAddressScreen()),
              );
              _fetchAddresses(); // Refresh addresses after adding a new one
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              color: Colors.grey[200],
              child: Text(
                "+Add New Address",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF2B5C74),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: addresses.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
                  ))
                : ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 ||
                              addresses[index - 1]["address_type"] !=
                                  address["address_type"])
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Text(
                                address["address_type"] ?? "Other Addresses",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          // Address Card
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddressIndex = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: selectedAddressIndex == index
                                    ? Colors.white
                                    : const Color(0xFFF6F6F6),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.w,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address["name"] ?? "N/A",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(address["area"] ?? "N/A"),
                                  Text(address["street"] ?? ""),
                                  Text(address["city"] ?? ""),
                                  Text(address["postal_code"] ?? ""),
                                  Text(
                                      "Mobile Number: ${address["phone"] ?? "N/A"}"),
                                ],
                              ),
                            ),
                          ),
                          // Edit Button (Visible only if selected)
                          if (selectedAddressIndex == index)
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.w,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle Edit Address
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                          color: Colors.grey, width: 1.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w, vertical: 10.h),
                                    ),
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  // "Remove" button has been removed as requested.
                                ],
                              ),
                            ),
                          SizedBox(height: 16.h),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
