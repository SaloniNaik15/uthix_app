import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStoreData extends StatefulWidget {
  const ManageStoreData({super.key});

  @override
  State<ManageStoreData> createState() => _ManageStoreDataState();
}

class _ManageStoreDataState extends State<ManageStoreData> {
  String storeName = "";
  String school = "";
  String logoFileName = "";
  String storeAddress = ""; // Static for now

  // Dummy analytics (can be linked to real API later)
  int netProfit = 60000;
  int totalProducts = 200;
  String visitors = "3.1K";
  int stockQuantity = 181;
  int lowStock = 20;
  int profitMargins = 2000;
  int bestSellingItems = 50;

  final String apiUrl = "https://admin.uthix.com/api/vendor/profile";
  final String logoBaseUrl = "https://admin.uthix.com/storage/images/logos/";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  Future<void> fetchStoreData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        log("❌ Auth token not found");
        return;
      }

      final response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          storeName = data['store_name'] ?? "";
          storeAddress = data['store_address'] ?? "";
          school = data['school'] ?? "";
          logoFileName = data['logo'] ?? "";
          isLoading = false;
        });
      } else {
        log("❌ Failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String logoUrl = "$logoBaseUrl$logoFileName";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Manage Store",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Store", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            buildStoreCard(logoUrl),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Analytics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: "This month",
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "This month", child: Text("This month")),
                    DropdownMenuItem(value: "Last month", child: Text("Last month")),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildAnalyticsCard("Net Profit", "₹$netProfit"),
                buildAnalyticsCard("Total Products", "$totalProducts"),
                buildAnalyticsCard("Visitors", visitors),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF5F5F5),
              ),
              child: const Column(
                children: [
                  Text("This graph shows revenue of 2 years", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Placeholder(fallbackHeight: 150), // Replace with fl_chart later
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildInfoTile("Quantity in Stock", "$stockQuantity"),
            buildInfoTile("Low Stock Items", "$lowStock"),
            buildInfoTile("Profit Margins", "₹$profitMargins"),
            buildInfoTile("Best Selling Items", "$bestSellingItems"),
          ],
        ),
      ),
    );
  }

  Widget buildStoreCard(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: logoFileName.isNotEmpty
                ? NetworkImage(imageUrl)
                : const AssetImage("assets/icons/profile.png") as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(school),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 4),
                    Text(storeAddress),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  Widget buildAnalyticsCard(String title, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF1F1F1),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFF1F1F1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}