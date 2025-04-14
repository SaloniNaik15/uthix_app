import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/UpdateStatus.dart';

class Orderdetails extends StatefulWidget {
  final int productId;

  const Orderdetails({super.key, required this.productId});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Orders Details",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Color(0xFF605F5F),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderAndTrackingCard(productId: widget.productId), // ✅ Fixed here
            SizedBox(height: 16),
            AddressSection(),
            SizedBox(height: 16),
            PriceDetailsSection(),
          ],
        ),
      ),
    );
  }
}

class OrderAndTrackingCard extends StatefulWidget {
  final int productId; // ✅ Add this

  const OrderAndTrackingCard({
    Key? key,
    required this.productId, // ✅ And this
  }) : super(key: key);

  @override
  State<OrderAndTrackingCard> createState() => _OrderAndTrackingCardState();
}

class _OrderAndTrackingCardState extends State<OrderAndTrackingCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFCFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFF4F4F4), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: 74678698759669160",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 12),

            // Order Summary
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Relativity: The Special and the General Theory",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text("by Albert Einstein",
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text("₹1500",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
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
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 12),

            // Tracking
            TrackingStep(
                title: "Order Confirmed", date: "Thu Jan 23", completed: true),
            SizedBox(height: 10),
            TrackingStep(
                title: "Shipped",
                date: "The item has left the facility, New Delhi, Thu Jan 23",
                completed: true),
            SizedBox(height: 10),
            TrackingStep(title: "Out for Delivery", completed: false),
            SizedBox(height: 20),
            TrackingStep(title: "Delivery Today by 11 PM", completed: false),
            SizedBox(height: 25),

            // ✅ Update Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateStatus(productId: widget.productId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child:
                    Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final String title;
  final String? date;
  final bool completed;

  TrackingStep({required this.title, this.date, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed ? Colors.green : Colors.grey,
            ),
            if (date != null)
              Container(height: 30, width: 2, color: Colors.green),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: completed ? Colors.black : Colors.grey),
              ),
              if (date != null)
                Text(
                  date!,
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFCFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFF4F4F4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            text: "Deliver to this address: ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFCFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFF4F4F4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
            _priceRow("Item price", "₹3000"),
            _priceRow("Shipping", "₹40"),
            Divider(),
            _priceRow("Total", "₹3040", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
