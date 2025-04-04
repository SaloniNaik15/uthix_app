import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSubscriptionDetails extends StatefulWidget {
  const ViewSubscriptionDetails({super.key});

  @override
  State<ViewSubscriptionDetails> createState() =>
      _ViewSubscriptionDetailsState();
}

class _ViewSubscriptionDetailsState extends State<ViewSubscriptionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: const Color(0xFFF6F6F6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Subscription Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10.h),
                  _buildCurrentPlanRow(),
                  SizedBox(height: 15.h),
                  _buildPriceRow(),
                  SizedBox(height: 20.h),
                  _buildDashedLine(),
                  SizedBox(height: 20.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Plan Features",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10.h),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeature("Downloadable Materials"),
                              _buildFeature("Live Classes (Recorded Only)"),
                              _buildFeature("Unlimited Courses"),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h), // Spacing before buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildButton("Cancel Subscription", Colors.red),
                      ),
                      SizedBox(width: 10), // Small spacing
                      Expanded(
                        child: _buildButton(
                            "Manage subscription", const Color(0xFF2B6074)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row for Current Plan
  Widget _buildCurrentPlanRow() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Plan",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text("You are currently on the Standard plan",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        _buildStatusContainer("Active", const Color(0xFF3B6BFD)),
      ],
    );
  }

  // Row for Rs 899
  Widget _buildPriceRow() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rs 899",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold)), // Rs 899 in bold
            Text("/month",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        _buildBorderContainer("Change Plan", const Color(0xFF2B6074)),
      ],
    );
  }

  Widget _buildStatusContainer(String text, Color color) {
    return Container(
      height: 25,
      width: 65,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
    );
  }

  Widget _buildBorderContainer(String text, Color color) {
    return Container(
      height: 33,
      width: 94,
      decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: color)),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: Color(0xFF2B6074)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          40,
          (index) => Text("-",
              style: TextStyle(color: Colors.black, fontSize: 18))),
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
