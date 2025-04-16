import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../UpcomingPage.dart';
import 'OrderConfirmed.dart';
import 'CardDetails.dart';

class PaymentScreen extends StatefulWidget {
  final String orderNumber;
  final int totalPrice;
  final int addressId;
  final int orderId;

  const PaymentScreen({
    super.key,
    required this.orderNumber,
    required this.totalPrice,
    required this.addressId,
    required this.orderId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentIndex = 0;
  bool isLoading = false;
  late Razorpay _razorpay;

  final List<String> paymentMethods = [
    "Credit Card",
    "Debit Card",
    "UPI",
    "Net Banking",
    "Google Pay",
    "COD"
  ];

  final List<String> paymentImages = [
    "assets/Payments/CreditCard.png",
    "assets/Payments/DebitCard.png",
    "assets/Payments/UPI.png",
    "assets/Payments/NetBanking.png",
    "assets/Payments/GooglePay.png",
    "assets/Payments/COD.png"
  ];

  @override
  void initState() {
    super.initState();
    // Initialize Razorpay instance and register event handlers.
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment successful with ID: ${response.paymentId}");
    // Update payment status as successful after a successful Razorpay payment.
    await _updatePaymentStatus("success", response.paymentId ?? "");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmed(
          orderId: widget.orderId,
          orderNumber: widget.orderNumber,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print(
        "Payment failed with code: ${response.code}, message: ${response.message}");
    // Update payment status as failed if Razorpay reports an error.
    await _updatePaymentStatus("failed", response.code.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment failed: ${response.message}"),
        duration: const Duration(seconds: 3),
        backgroundColor: Color(0xFF2B5C74),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  // This method posts the payment status update to your API.
  Future<void> _updatePaymentStatus(String status, String transactionId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token =
          prefs.getString('auth_token'); // Retrieve token dynamically

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Authentication failed. Please log in again.")),
        );
        return;
      }

      print(
          "Updating payment status: status=$status, transactionId=$transactionId, orderId=${widget.orderId}");

      final response = await http
          .post(
        Uri.parse('https://admin.uthix.com/api/update-payment-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Dynamic Token
        },
        body: jsonEncode({
          'order_id': widget.orderId,
          'status': status,
          'transaction_id': transactionId,
        }),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception(
              "Connection timed out while updating payment status.");
        },
      );

      print("Update Payment Status Response: ${response.body}");
      if (response.statusCode != 201) {
        print(
            "Error updating payment status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating payment status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating payment: $e")),
      );
    }
  }

  // This method creates the Razorpay order by calling your API and then opens the Razorpay checkout.
  Future<void> _startPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
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
        return;
      }

      print(
          "Starting payment request for order ID: ${widget.orderId}, amount: ${widget.totalPrice}");

      // If your backend expects the amount in rupees, use widget.totalPrice.
      // If it expects paise then multiply it by 100.
      final requestPayload = {
        'order_id': widget.orderId,
        'amount': widget.totalPrice, // or widget.totalPrice * 100
        'currency': 'INR',
        'payment_method': (paymentMethods[selectedPaymentIndex] == "Google Pay")
            ? "UPI"
            : paymentMethods[selectedPaymentIndex],
      };

      print("Request Payload: $requestPayload");

      final response = await http
          .post(
        Uri.parse('https://admin.uthix.com/api/create-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestPayload),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception(
              "Connection timed out. Please check your internet connection and try again.");
        },
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          var options = {
            'key':
                'your_razorpay_key_here', // Replace with your actual Razorpay key
            // Multiply by 100 if the backend returns rupees but Razorpay expects paise
            'amount': responseData[
                'amount'], // Consider: responseData['amount'] * 100,
            'currency': responseData['currency'],
            'name': 'BuyBooks',
            'description': 'Order Payment',
            'order_id': responseData['razorpay_order_id'],
          };

          print("Opening Razorpay with options: $options");
          try {
            _razorpay.open(options);
          } catch (e) {
            print('Error opening Razorpay: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error opening Razorpay: $e"),
                duration: const Duration(seconds: 1),
                backgroundColor: Color(0xFF2B5C74),
                behavior: SnackBarBehavior.floating,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        } else {
          print("Failed to create Razorpay order: ${responseData['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Failed to create Razorpay order: ${responseData['message']}"),
              duration: const Duration(seconds: 1),
              backgroundColor: Color(0xFF2B5C74),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception("Authentication failed. Please check your API key.");
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            "Invalid request: ${errorData['message'] ?? 'Unknown error'}");
      } else {
        throw Exception("Server returned status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Payment request error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error connecting to payment server: $e"),
          duration: const Duration(seconds: 1),
          backgroundColor: Color(0xFF2B5C74),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // This method determines the payment flow based on the selected payment method.
  void _handlePayment() {
    // If COD is selected, the payment is marked as successful automatically.
    if (paymentMethods[selectedPaymentIndex] == "COD") {
      _updatePaymentStatus("success", "COD").then((_) {
        Navigator.pushReplacement(
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
    // For UPI and Google Pay, call the API to create the Razorpay order and open the checkout.
    else if (paymentMethods[selectedPaymentIndex] == "UPI" ||
        paymentMethods[selectedPaymentIndex] == "Google Pay") {
      _startPayment();
    }
    // For other methods (Credit Card, Debit Card, Net Banking) navigate to the card payment screen.
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UnderConstructionScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clear Razorpay instance to prevent memory leaks.
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the responsive payment screen UI using ScreenUtil.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F), size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your Payment Gateway",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 30.h,
                      childAspectRatio: 1,
                    ),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentIndex = index;
                          });
                        },
                        child: Material(
                          elevation: 5,
                          color: Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(15.r),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedPaymentIndex == index
                                    ? Colors.blue
                                    : Color(0xFFFCFCFC),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(paymentImages[index], height: 50.h),
                                SizedBox(height: 8.h),
                                Text(paymentMethods[index],
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Your Bill Amount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Divider(),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Item price",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("₹${widget.totalPrice}")
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("₹${widget.totalPrice}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B5C74),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r)),
                    ),
                    child: Text("Check Out",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}