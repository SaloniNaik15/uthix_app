import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentWallet extends StatefulWidget {
  const StudentWallet({super.key});

  @override
  State<StudentWallet> createState() => _StudentWalletState();
}

class _StudentWalletState extends State<StudentWallet> {
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
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Section (Title + Balance in a Row)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wallet Title & Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wallet",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Credit id added to your wallet\nwith every order",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Wallet Balance Container
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B5C74),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C7D2B).withOpacity(0.5),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 25.sp,
                        color: Colors.green,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "₹299",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Balance",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // Cashback & Wallet Usage Sections
            _buildWalletFeature(
              number: "1",
              title: "Receive cashback with every order",
              description:
              "50% cashback will be credited to your wallet with every order",
            ),
            SizedBox(height: 20.h),
            _buildWalletFeature(
              number: "2",
              title: "Save more by using wallet cash",
              description:
              "Buy items and get various discounts by using wallet cash",
            ),
          ],
        ),
      ),
    );
  }

  // Wallet Feature Widget
  Widget _buildWalletFeature({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
