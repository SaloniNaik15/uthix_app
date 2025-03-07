import 'package:flutter/material.dart';

// ignore: camel_case_types
class orderConfirmed extends StatefulWidget {
  const orderConfirmed({super.key, required int orderId, required String orderNumber});

  @override
  State<orderConfirmed> createState() => _orderConfirmedState();
}

// ignore: camel_case_types
class _orderConfirmedState extends State<orderConfirmed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Seller_dashboard_images/ManageStoreBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centers text horizontally
              children: [
                Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: "Urbanist",
                  ),
                ),
                SizedBox(height: 20), // Space between the texts
                Row(
                  mainAxisSize: MainAxisSize.min, // Wrap content
                  children: [
                    Text(
                      "Order Confirmed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF2B5C74),
                        fontFamily: "Urbanist",
                      ),
                    ),
                    SizedBox(width: 6), // Space between text and icon
                    Container(
                      padding: EdgeInsets.all(6), // Padding inside the red box
                      decoration: BoxDecoration(
                        color: Colors.blueAccent, // Red background for the icon
                        shape: BoxShape.circle, // Circular background
                      ),
                      child: Icon(Icons.check,
                          color: Colors.white,
                          size: 18), // Icon inside red background
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
