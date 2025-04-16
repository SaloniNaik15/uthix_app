import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rejected extends StatefulWidget {
  final String status;
  const Rejected({super.key, required this.status});

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  List<dynamic> orders = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
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

      if (response.statusCode == 200) {
        setState(() {
          orders = List.from(response.data['orders'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      log('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Showing loading indicator
          : hasError
              ? const Center(child: Text("Failed to load orders"))
              : orders.isEmpty
                  ? const Center(child: Text("No rejected orders found"))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         // _buildSearchBar(),
                          //const SizedBox(height: 15),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2B5C74),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Rejected",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
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
              _buildOrderDetails(order),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 12),
              _buildAddressSection(order['shipping_address']),
              _buildDivider(),
              const SizedBox(height: 10),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection(dynamic address) {
    if (address is! Map) {
      return const Text(
        "Shipping Address: Not available",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      );
    }

    final name = address['name'] ?? 'N/A';
    final landmark = address['landmark'] ?? 'N/A';
    final city = address['city'] ?? 'N/A';
    final state = address['state'] ?? 'N/A';

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
          "$name, $landmark, $city, $state",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(dynamic order) {
    var product = (order['items'] is List && order['items'].isNotEmpty)
        ? order['items'][0]
        : {};

    String title = product['title'] ?? "Unknown Product";
    String description = product['description'] ?? "No description";
    String price = product['price']?.toString() ?? "0";
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
                title,
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
                "₹$price",
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
  }

  Widget _buildImageCard(String? thumbnailImg) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: thumbnailImg != null && thumbnailImg.isNotEmpty
            ? Image.network(
                "https://admin.uthix.com/storage/image/products/$thumbnailImg",
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
              )
            : Image.asset(
                "assets/Seller_dashboard_images/book.jpg",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Rejected",
              style: TextStyle(color: Colors.white),
            ),
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

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF3F3F3),
      thickness: 2,
    );
  }
}
