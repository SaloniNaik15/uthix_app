import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStatus extends StatefulWidget {
  final int productId;

  const UpdateStatus({super.key, required this.productId});

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  String selectedStatus = "Cancelled";
  String tempStatus = "Cancelled";
  Dio dio = Dio();

  Future<void> updateOrderStatus(int productId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        return;
      }

      var response = await Dio().post(
        'https://admin.uthix.com/api/vendor-update-order-status',
        data: jsonEncode({
          'product_id': productId,
          'status': status,
        }),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        log('✅ Order status updated successfully');
      } else {
        log('❌ Failed to update order status');
      }
    } catch (e) {
      log("❌ Error updating order status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vendor Order Status Update',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              width: 350.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #74678698759669160",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Book Name: Maths",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(height: 4.h),
                            RichText(
                              text: TextSpan(
                                text: "Current Status: ",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: selectedStatus,
                                    style: TextStyle(
                                      color: selectedStatus == "Cancelled"
                                          ? Colors.red
                                          : selectedStatus == "Accepted"
                                              ? Colors.green
                                              : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Student: John Doe",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/Seller_dashboard_images/book.jpg',
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Update Status:",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempStatus,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(
                              value: "Cancelled", child: Text("Cancelled")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tempStatus = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final parsedId = widget.productId;
                        if (parsedId != null) {
                          updateOrderStatus(parsedId, 'rejected');
                          setState(() {
                            selectedStatus = tempStatus;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Status updated to $selectedStatus'),
                            ),
                          );
                        } else {
                          log("❌ Invalid product ID");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid product ID.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5C74),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        "Update Status",
                        style: TextStyle(fontSize: 15.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
