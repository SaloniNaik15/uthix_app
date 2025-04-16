import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProcessing extends StatefulWidget {
  final int orderId;

  const OrderProcessing({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderProcessing> createState() => _OrderProcessingState();
}

class _OrderProcessingState extends State<OrderProcessing> {
  // Store fetched order details
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;
  bool hasError = false;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://admin.uthix.com/api/orders',
  ));

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      // Retrieve the token dynamically from SharedPreferences.
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
        setState(() {
          hasError = true;
          isLoading = false;
        });
        return;
      }

      // Call the API using the relative URL and inject the token into the request headers.
      final response = await _dio.get(
        '/${widget.orderId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          orderDetails = response.data['order'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Orders Details",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
              ),
            )
          : hasError || orderDetails == null
              ? const Center(
                  child: Text("Failed to load order details."),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Single Card containing Order Details and Tracking
                      OrderAndTrackingCard(
                        orderDetails: orderDetails!,
                      ),
                      const SizedBox(height: 16),
                      // Separate Address Section
                      AddressSection(
                        orderDetails: orderDetails!,
                      ),
                      const SizedBox(height: 16),
                      // Separate Price Details Section
                      PriceDetailsSection(
                        orderDetails: orderDetails!,
                      ),
                    ],
                  ),
                ),
    );
  }
}

//  Single Card for Order Details and Tracking
class OrderAndTrackingCard extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const OrderAndTrackingCard({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get items array from the order details.
    final items = orderDetails['order_items'] ?? [];
    // Grab the first item if it exists.
    final firstItem = items.isNotEmpty ? items[0] : null;
    // Extract product data.
    final productTitle = firstItem?['product']?['title'] ?? 'N/A';
    final productAuthor = firstItem?['product']?['author'] ?? '';
    final productPrice = orderDetails['total_amount'] ?? '0';

    return Card(
      color: const Color(0xFFFCFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF4F4F4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID displayed using data from your API.
            Text(
              "Order ID: ${orderDetails['id'] ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 12),
            // Order Summary
            Row(
              children: [
                // Product Info section.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        productAuthor.isNotEmpty
                            ? "by $productAuthor"
                            : "No Author",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹$productPrice",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Product Image (using a local asset; update if using network image)
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            // Static Tracking Section (adjust this as per your real tracking data)
            TrackingStep(
              title: "Order Confirmed",
              date: "Thu Jan 23",
              completed: true,
            ),
            const SizedBox(height: 10),
            TrackingStep(
              title: "Shipped",
              date: "The item has left the facility, New Delhi, Thu Jan 23",
              completed: true,
            ),
            const SizedBox(height: 10),
            TrackingStep(
              title: "Out for Delivery",
              completed: false,
            ),
            const SizedBox(height: 20),
            TrackingStep(
              title: "Delivery Today by 11 PM",
              completed: false,
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// Tracking Step Widget
class TrackingStep extends StatelessWidget {
  final String title;
  final String? date;
  final bool completed;

  const TrackingStep({
    Key? key,
    required this.title,
    this.date,
    required this.completed,
  }) : super(key: key);

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
              Container(
                height: 30,
                width: 2,
                color: Colors.green,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: completed ? Colors.black : Colors.grey,
                ),
              ),
              if (date != null)
                Text(
                  date!,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Separate Address Section
class AddressSection extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const AddressSection({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the full address from the order details.
    final shippingAddress = orderDetails['address']?['full_address'] ?? 'N/A';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        color: const Color(0xFFF6F6F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Deliver to: $shippingAddress",
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Separate Price Details Section
class PriceDetailsSection extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const PriceDetailsSection({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data extracted from API response.
    final itemPrice = orderDetails['sub_total'] ?? 0;
    final shippingCost = orderDetails['shipping'] ?? 0;
    final total = orderDetails['total_amount'] ?? 0;

    return Card(
      color: const Color(0xFFFCFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF4F4F4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _priceRow("Item price", "₹$itemPrice"),
            _priceRow("Shipping", "₹$shippingCost"),
            const Divider(),
            _priceRow("Total", "₹$total", isBold: true),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}