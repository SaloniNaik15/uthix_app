import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/OrderDetails.dart';

class InTransit extends StatefulWidget {
  final String status;
  const InTransit({super.key, required this.status});

  @override
  State<InTransit> createState() => _InTransitState();
}

class _InTransitState extends State<InTransit> {
  late List<dynamic> orders = [];
  late Dio dio;
  bool isLoading = true; // Track loading state

  @override
  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchOrders();
  }

  // Fetch orders from the API
  Future<void> fetchOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        setState(() {
          isLoading = false; // Stop loading if token is not found
        });
        return;
      }

      final response = await dio.get(
        'https://admin.uthix.com/api/vendor-order-status/${widget.status}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = response.data['orders'].map((order) {
            List<dynamic> itemIds = order['items'].map((item) {
              return item['id'];
            }).toList();

            return {
              'order_id': order['order_id'],
              'item_ids': itemIds,
              'shipping_address': order['shipping_address'],
              'items': order['items'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('Failed to load orders: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : orders.isEmpty
              ? const Center(child: Text("No orders found."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 15),
                      _buildDivider(),
                      const SizedBox(height: 20),
                      ...orders
                          .map((order) => _buildOrderCard(context, order))
                          .toList(),
                      const SizedBox(height: 15),
                      _buildDivider(),
                    ],
                  ),
                ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2B5C74),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Center(
        child: const Text(
          "In Transit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: _buildContainer(
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search in orders",
                prefixIcon: Icon(Icons.search, color: Color(0xFF605F5F)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildContainer(
          child: IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF605F5F)),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic order) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFFFCFCFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Color(0xFFF4F4F4), width: 1),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderDetails(context, order),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 12),
              _buildAddressSection(order['shipping_address']),
              _buildDivider(),
              const SizedBox(height: 10),
              _buildActionButton(context, order['items']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection(dynamic shippingAddress) {
    if (shippingAddress == null) {
      return const Text(
        "Shipping Address: Not available",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shipping Address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${shippingAddress['landmark'] ?? 'No landmark available'}, ${shippingAddress['city'] ?? 'No city available'}, ${shippingAddress['state'] ?? 'No state available'}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context, dynamic order) {
    if (order == null || order['items'] == null) {
      return const Center(child: Text("No items found in the order."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: order['items'].map<Widget>((product) {
        if (product == null) {
          return const SizedBox.shrink();
        }

        String? thumbnailImg = product['image'];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCard(thumbnailImg),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? "Unknown Product",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['description'] ?? "No description available",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${product['price'] ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildImageCard(String? thumbnailImg) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: thumbnailImg != null && thumbnailImg.isNotEmpty
            ? Image.network(
                'https://admin.uthix.com/storage/image/products/$thumbnailImg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/Seller_dashboard_images/book.jpg",
                      height: 100, width: 100, fit: BoxFit.cover);
                },
              )
            : Image.asset("assets/Seller_dashboard_images/book.jpg",
                height: 100, width: 100, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, dynamic items) {
    return Column(
      children: items.map<Widget>((product) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  int productId = product['id'];
                  // Log the product id before navigation
                  log("Navigating to OrderDetails with Product ID: $productId");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Orderdetails(productId: productId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5C74),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF3F3F3),
      thickness: 2,
    );
  }
}
