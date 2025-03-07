import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'OrderConfirmed.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key, required int orderId, required String orderNumber, required int totalPrice});

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  bool _isProcessing = false;

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isProcessing = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => orderConfirmed(orderId: 1, orderNumber: '',)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Give your Card Details",
          style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Credit Card / Debit Card",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("2 Items"),
                    SizedBox(width: 16),
                    Text("Total ₹3040",
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF605F5F)),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Card Holder Name",
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF605F5F)),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Expiry Date (MM/YY)",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF605F5F)),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "CVV",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF605F5F)),
                          border: OutlineInputBorder(),
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
                    backgroundColor: Color(0xFF2B5C74),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text("Pay",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Urbanist',
                          color: Colors.white)),
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
                      size: 100.0,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Please wait until your payment is received",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold),
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
