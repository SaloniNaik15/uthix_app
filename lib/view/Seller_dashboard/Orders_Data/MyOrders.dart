import 'package:flutter/material.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/Deliverd.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/InTransit.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/Pending.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/Rejected.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/Returned.dart';
import 'OrderDetails.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildGridContainers(context),
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
          "Orders and Tracking",
          style: TextStyle(
            fontSize: 18,
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

  Widget _buildGridContainers(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _roundedBox("PENDING", const Color(0xFF35B395), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const Pending(
                            status: 'pending',
                          )));
            }),
            _roundedBox("IN TRANSIT", const Color(0xFF18617E), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => InTransit(
                            status: 'intransit',
                          )));
            }),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _roundedBox("DELIVERED", const Color(0xFFCA752A), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Deliverd(
                            status: 'delivered',
                          )));
            }),
            _roundedBox("REJECTED", const Color(0xFFF44236), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Rejected(
                            status: 'rejected',
                          )));
            }),
            // _roundedBox("RETURNED", const Color(0xFF149643), () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (_) => Returned(status: 'returned',)));
            // }),
          ],
        ),
        const SizedBox(height: 18),
        Center(
            // child: _roundedBox("REJECTED", const Color(0xFFF44236), () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (_) => Rejected(status: 'rejected',)));
            // }),
            ),
      ],
    );
  }

  Widget _roundedBox(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 169,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
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
