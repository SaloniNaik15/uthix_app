import 'dart:async';
import 'package:flutter/material.dart';

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
    Timer(const Duration(seconds: 5), () {
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
              const Text(
                "Payment Successful",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Urbanist",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Order Confirmed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: const Color(0xFF2B5C74),
                      fontFamily: "Urbanist",
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Order Number: ${widget.orderNumber}",
                style: const TextStyle(fontSize: 16, fontFamily: "Urbanist"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Redirecting to order tracking...",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
