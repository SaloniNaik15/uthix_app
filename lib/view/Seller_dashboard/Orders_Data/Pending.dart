import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/InTransit.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/Rejected.dart';
import 'OrderDetails.dart';

class Pending extends StatefulWidget {
  final String status;
  const Pending({super.key, required this.status});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
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

      var response = await Dio().get(
        'https://admin.uthix.com/api/vendor-order-status/${widget.status}',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          orders = response.data['orders'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("❌ Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateOrderStatus(
      BuildContext context, int productId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        return;
      }

      var response = await Dio().post(
        'https://admin.uthix.com/api/vendor-update-order-status',
        data: jsonEncode({'product_id': productId, 'status': status}),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        log('✅ Order status updated successfully');

        // if (status == 'intransit') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => InTransit(status: 'in_transit')),
        //   );
        // } else if (status == 'rejected') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => Rejected(status: 'rejected')),
        //   );
        // }
      } else {
        log('❌ Failed to update order status');
      }
    } catch (e) {
      log("❌ Error updating order status: $e");
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
              ? const Center(child: Text("No orders found."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
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
      title: const Center(
        child: Text(
          "Pending Orders",
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
    var shipping = order['shipping_address'];

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
              if (order['items'] != null)
                ...order['items'].map<Widget>((product) {
                  return _buildOrderDetails(context, product);
                }).toList(),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 12),
              _buildAddressSection(shipping),
              _buildDivider(),
              const SizedBox(height: 10),
              if (order['items'] != null && order['items'].isNotEmpty)
                _buildActionButtons(context, order['items'][0]['id']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, dynamic product) {
    String? imageUrl = product['image'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageCard(imageUrl),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['title'] ?? "Unknown Product",
                style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                product['description'] ?? "No description available",
                style:

                    TextStyle(color: Colors.grey[700], ),

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
    );
  }

  Widget _buildImageCard(String? imageUrl) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                'https://admin.uthix.com/storage/image/products/$imageUrl',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                    "assets/Seller_dashboard_images/book.jpg",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover),
              )
            : Image.asset("assets/Seller_dashboard_images/book.jpg",
                height: 100, width: 100, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAddressSection(dynamic shipping) {
    if (shipping == null) {
      return const Text("No shipping address available.",
          style: TextStyle(fontSize: 14, color: Colors.red));
    }

    String addressText =
        "${shipping['name'] ?? ''}, ${shipping['phone'] ?? ''}, "
        "${shipping['city'] ?? ''}, ${shipping['state'] ?? ''}, ${shipping['landmark'] ?? ''}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shipping Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(addressText,
            style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, int productId) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              updateOrderStatus(context, productId, 'intransit');
              log("Accept Order for product ID: $productId");
              showDialog(
                context: context,
                builder: (_) => OrderStatusDialog(
                  statusMessage: 'Order Accepted Successfully',
                  iconCircleColor: Colors.green,
                  statusIcon: Icons.check,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B5C74),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Accept Order",
                style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              log("Decline Order for product ID: $productId");
              showDialog(
                context: context,
                builder: (_) => OrderStatusDialog(
                  statusMessage: 'Are you sure you want to reject the order?',
                  iconCircleColor: Colors.red,
                  statusIcon: Icons.close,
                  showButtons: true,
                  onOkPressed: () {
                    updateOrderStatus(context, productId, 'rejected');
                    Navigator.pop(context);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44236),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Decline Order",
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF4F4F4)),
      child: child,
    );
  }

  Widget _buildDivider() => const Divider(color: Color(0xFFF4F4F4), height: 1);
}

class OrderStatusDialog extends StatelessWidget {
  final String statusMessage;
  final Color iconCircleColor;
  final IconData statusIcon;
  final bool showButtons;
  final VoidCallback? onOkPressed;

  const OrderStatusDialog({
    super.key,
    required this.statusMessage,
    required this.iconCircleColor,
    required this.statusIcon,
    this.showButtons = false,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: iconCircleColor,
            radius: 40,
            child: Icon(statusIcon, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 20),
          Text(statusMessage,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (showButtons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDialogButton(
                    "OK", const Color(0xFF2B5C74), onOkPressed ?? () {}),
                _buildDialogButton(
                    "Cancel", Colors.red, () => Navigator.pop(context)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
