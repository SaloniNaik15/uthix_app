import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/UpcomingPage.dart';
import '../../../modal/Snackbar.dart';
import 'Order_Processing.dart';

class OrdersTrackingPage extends StatefulWidget {
  final int? orderId;

  const OrdersTrackingPage({Key? key, this.orderId}) : super(key: key);

  @override
  _OrdersTrackingPageState createState() => _OrdersTrackingPageState();
}

class _OrdersTrackingPageState extends State<OrdersTrackingPage> {
  List orders = [];
  bool isLoading = true;

  // Set the base URL for orders.
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://admin.uthix.com/api/orders',
  ));

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      SnackbarHelper.showMessage(
        context,
        message: 'Authentication failed. Please log in again.',
      );
      return;
    }

    try {
      final response = await _dio.get(
        '',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        List fetchedOrders = response.data['orders'] ?? [];

        fetchedOrders.sort((a, b) {
          DateTime dateA = DateTime.parse(a['created_at']);
          DateTime dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA);
        });

        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } else {
        print('Failed to load orders: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Orders and Tracking",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
        ),
      )
          : orders.isEmpty
          ? const Center(child: Text("No orders found."))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search in orders",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF605F5F),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune,
                          color: Color(0xFF605F5F)),
                      onPressed: () {
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(
                  color: Color(0xFF605F5F), thickness: 2),
              const SizedBox(height: 20),
              // List of orders.
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];


                  final orderStatus = order['status'] ?? 'In Process';
                  final orderDate = order['created_at'] != null
                      ? order['created_at'].substring(0, 10)
                      : "N/A";

                  // Extract details of the first order item.
                  final items = order['order_items'] ?? [];
                  final firstItem =
                  items.isNotEmpty ? items[0] : null;
                  final bookName = firstItem != null &&
                      firstItem['product'] != null
                      ? firstItem['product']['title'] ?? 'Book Name'
                      : 'Book Name';
                  final description = firstItem != null &&
                      firstItem['product'] != null
                      ? firstItem['product']['description'] ??
                      'Description'
                      : 'Description';
                  final price =
                      "₹${order['total_amount'] ?? '0'}";

                  return OrderCard(
                    orderStatus: orderStatus,
                    orderDate: orderDate,
                    bookName: bookName,
                    description: description,
                    price: price,
                    imagePath:
                    'assets/Seller_dashboard_images/book.jpg',
                    onUpdateStatus: () {
                      // When this button is tapped,
                      // navigate to OrderProcessing page by passing the order id.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderProcessing(
                            orderId: order['id'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderStatus;
  final String orderDate;
  final String bookName;
  final String description;
  final String price;
  final String imagePath;
  final VoidCallback onUpdateStatus;

  const OrderCard({
    Key? key,
    required this.orderStatus,
    required this.orderDate,
    required this.bookName,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order status row.
        Row(
          children: [
            Image.asset('assets/icons/orderIcon.png', height: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderStatus,
                  style: const TextStyle(
                    fontSize: 16,

                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B5C74),
                  ),
                ),
                Text(
                  orderDate,
                  style: const TextStyle(
                    fontSize: 14,

                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Order details card.
        SizedBox(
          height: 380,
          width: double.infinity,
          child: Card(
            color: const Color(0xFFFCFCFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                color: Color(0xFFF4F4F4),
                width: 1,
              ),
            ),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            height: 100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Book details.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookName,
                              style: const TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey[700],

                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          ],
                        ),
                      ),
                      // Forward arrow button.
                      IconButton(
                        onPressed: onUpdateStatus,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 12),
                  // Return/Exchange buttons.
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFAFAFAF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            // Handle Return.
                          },
                          child: const Text(
                            "Return",
                            style: TextStyle(
                              color: Colors.black,

                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFAFAFAF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            // Handle Exchange.
                          },
                          child: const Text(
                            "Exchange",
                            style: TextStyle(
                              color: Colors.black,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 10),
                  // Star rating and feedback.
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          5,
                              (index) =>
                          const Icon(Icons.star_border_outlined, size: 28),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Handle feedback.
                            },
                            child: const Text(
                              "Give feedback and Earn Credit",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
