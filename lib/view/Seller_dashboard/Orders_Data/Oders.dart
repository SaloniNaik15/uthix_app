import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'OrderDetails.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    const String apiUrl = "https://admin.uthix.com/api/vendor/all-orders";
    const String token = "19|oPune0eP5bVOdqzBDTUww0Gc8Mc0KzoEZbKaZ5ondf6a7ca9";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      log("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}"); // Logs full API response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Parsed Data: $data"); // Logs parsed JSON data

        if (data['status']) {
          setState(() {
            orders = data['orders'];
          });
        }
      } else {
        throw Exception("Failed to load orders: ${response.body}");
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Orders and Tracking",
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
          color: Color(0xFF605F5F),
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
              //_buildOrderAddress(order),
              const SizedBox(height: 10),
              _buildUpdateStatusButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, dynamic order) {
    var product = order['order_items'][0]['product'];
    String? thumbnailImg = product['thumbnail_img'];

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
                "₹${order['total_amount']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Orderdetails()),
            );
          },
          icon:
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget _buildOrderAddress(dynamic order) {
  //   return Text.rich(
  //     TextSpan(
  //       children: [
  //         const TextSpan(
  //           text: "Order Number: ",
  //           style:
  //               TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w400),
  //         ),
  //         TextSpan(
  //           text: order['order_number'] ?? "N/A",
  //           style: const TextStyle(
  //               fontFamily: 'Urbanist', fontWeight: FontWeight.w400),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildUpdateStatusButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Orderdetails()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B5C74),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Text(
          "Update Status",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
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

  Widget _buildImageCard(String? thumbnailImg) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: thumbnailImg != null && thumbnailImg.isNotEmpty
            ? Image.network(
                thumbnailImg,
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

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF605F5F),
      thickness: 2,
    );
  }
}
