import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/OrderStatus.dart';

class Deliverd extends StatefulWidget {
  final String status;
  const Deliverd({super.key, required this.status});

  @override
  State<Deliverd> createState() => _DeliverdState();
}

class _DeliverdState extends State<Deliverd> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        return;
      }
      final dio = Dio();

      final response = await dio.get(
        'https://admin.uthix.com/api/vendor-order-status/${widget.status}',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data != null && response.data['status'] == true) {
        setState(() {
          orders = response.data['orders'];
          isLoading = false;
        });
      } else {
        // Handle case where the response is not successful
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors like network issues or wrong API call
      setState(() {
        isLoading = false;
      });
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2B5C74)))
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
          "Delivered",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
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
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection(Map<String, dynamic> address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shipping Address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Urbanist',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${address['name']}, ${address['landmark']}, ${address['city']}, ${address['state']}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Urbanist',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderStatus(),
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
  }

  Widget _buildOrderDetails(BuildContext context, dynamic order) {
    var product = order['items'][0];
    String thumbnailImg = product['image'];

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
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product['description'] ?? "No description available",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "₹${product['price']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildImageCard(String thumbnailImg) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://admin.uthix.com/storage/image/products/$thumbnailImg',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/Seller_dashboard_images/book.jpg",
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF3F3F3),
      thickness: 2,
    );
  }
}
