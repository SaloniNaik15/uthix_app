import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Student Account Details/Order_Tracking.dart';

class OrderConfirmed extends StatefulWidget {
  final int orderId;
  final String orderNumber;
  const OrderConfirmed({
    Key? key,
    required this.orderId,
    required this.orderNumber,
  }) : super(key: key);

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  void initState() {
    super.initState();
    // After 5 seconds, redirect to the OrderTracking page.
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersTrackingPage(orderId: widget.orderId),
        ),
      );
    });
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Seller_dashboard_images/ManageStoreBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centers content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers text horizontally
            children: [
              Text(
                "Payment Successful",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Order Confirmed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: const Color(0xFF2B5C74),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                "Order Number: ${widget.orderNumber}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10.h),
              Text(
                "Redirecting to order tracking...",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
