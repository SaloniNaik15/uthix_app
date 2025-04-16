import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/ReturnDetails.dart';

class Returned extends StatefulWidget {
  final String status;
  const Returned({super.key, required this.status});

  @override
  State<Returned> createState() => _ReturnedState();
}

class _ReturnedState extends State<Returned> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReturnedOrders();
  }

  Future<void> fetchReturnedOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        return;
      }

      Dio dio = Dio();

      final response = await dio.get(
        'https://admin.uthix.com/api/vendor-order-status/${widget.status}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['orders'] != null && data['orders'] is List) {
          setState(() {
            orders = data['orders'];
            isLoading = false;
          });
        } else {
          log("❌ 'orders' not found or invalid format: ${data['orders']}");
          setState(() => isLoading = false);
        }
      } else {
        print("Error: ${response.statusMessage}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Failed to fetch orders: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No returned orders found.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //_buildSearchBar(),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2B5C74),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Center(
        child: Text(
          "Returned",
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
    var product = order['items'][0];
    String? thumbnailImg = product['image'];

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
              Row(
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
                          "₹${product['price']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _buildAddressSection(dynamic address) {
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
          "${address['street_address'] ?? ''} ${address['landmark'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['pincode'] ?? ''}",
          style: const TextStyle(
            fontSize: 14,
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
                  builder: (context) => ReturnDetailsPage(),
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
