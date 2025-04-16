import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'OrderConfirmed.dart';

class CardPaymentScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;
  final int totalPrice;

  const CardPaymentScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.totalPrice,
  });

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  bool _isProcessing = false;

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isProcessing = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmed(
            orderId: widget.orderId,
            orderNumber: widget.orderNumber,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: const Color(0xFF605F5F), size: 20.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Give your Card Details",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Credit Card / Debit Card",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text("2 Items", style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 16.w),
                    Text("Total ₹3040",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  ],
                ),
                SizedBox(height: 40.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    labelStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF605F5F)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 30.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Card Holder Name",
                    labelStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF605F5F)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Expiry Date (MM/YY)",
                          labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF605F5F)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "CVV",
                          labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF605F5F)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5C74),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text("Pay",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFadingCircle(
                      color: Colors.blueAccent,
                      size: 100.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Please wait until your payment is received",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
