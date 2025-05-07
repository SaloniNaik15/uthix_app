import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Student_Pages/Buy_Books/BookDetails.dart';
import 'Customer Photos.dart';
import 'CustomerReviews.dart';

class Viewdetails extends StatefulWidget {
  final Map<String, dynamic> product;
  const Viewdetails({super.key, required this.product});

  @override
  State<Viewdetails> createState() => _ViewdetailsState();
}

class _ViewdetailsState extends State<Viewdetails> {
  String? accessToken;
  List<String> allImageUrls = [];
  bool isLoading = true;
  Dio dio = Dio();
  double? rating;
  String? review;
  late Map<String, dynamic> productDetails;

  @override
  void initState() {
    super.initState();
    productDetails = widget.product;
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchReviewAndRating();
    await fetchProducts();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    setState(() {
      accessToken = token;
    });
  }

  Future<void> fetchReviewAndRating() async {
    final String url = 'https://admin.uthix.com/api/vendor/review/${productDetails['id']}';

    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          if (data['reviews']?.isNotEmpty ?? false) {
            rating = (data['reviews'][0]['rating'] as num?)?.toDouble() ?? 0.0;
            review = data['reviews'][0]['review'] ?? "No review available";
          } else {
            rating = 0.0;
            review = "No review available";
          }
        });
      }
    } catch (e) {
      log("❌ Error fetching review: $e");
      setState(() {
        rating = 0.0;
        review = "No review available";
      });
    }
  }

  Future<void> fetchProducts() async {
    const String url = 'https://admin.uthix.com/api/get/vendor/products';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        List<dynamic> fetchedProducts = jsonResponse['products'];
        List<String> imageUrls = [];

        for (var product in fetchedProducts) {
          if (product['images'] != null && product['images'].isNotEmpty) {
            for (var image in product['images']) {
              final imageUrl = 'https://admin.uthix.com/storage/image/products/${image['image_path']}';
              imageUrls.add(imageUrl);
            }
          }
        }

        setState(() {
          allImageUrls = imageUrls;
          isLoading = false;
        });
      } else {
        log("❌ Failed to fetch products: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      log("❌ Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: allImageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        allImageUrls[index],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              productDetails['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) => const Icon(Icons.star, size: 14, color: Colors.amber)),
            ),
            const SizedBox(height: 10),
            Text(
              "₹ ${productDetails['price'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(productDetails['author'] ?? "Author", style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 10),
                const Text("|", style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 10),
                Text(productDetails['language'] ?? "Language", style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 10),
                const Text("|", style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 10),
                const Text("14th edition", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              productDetails['description'] ?? "No description",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatItemVendor(title: 'RATING', value: (rating ?? 0.0).toStringAsFixed(1), icon: Icons.star),
                StatItemVendor(title: 'ALL BOOKS', value: productDetails['stock'].toString(), icon: Icons.book),
                StatItemVendor(title: 'BOOKS SOLD', value: '20', icon: Icons.book),
              ],
            ),
            const SizedBox(height: 20),
            deliveryInstructions(),
            const SizedBox(height: 20),
            reviewAndRating(rating, review),
            const SizedBox(height: 20),
            CustomerReview(reviews: [],),
            const SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                onPressed: () => print("Edit Details Pressed"),
                child: const Text("Edit Details", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget reviewAndRating(dynamic rating, dynamic review) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Reviews & Ratings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 75,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF2B5C74),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    (rating ?? 0.0).toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              review ?? "No review available",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget deliveryInstructions() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDeliveryRow("assets/Seller_dashboard_images/order_outline.png", "Takes 4 days approx to get delivered"),
      const SizedBox(height: 10),
      _buildDeliveryRow("assets/Seller_dashboard_images/COD_icon.png", "COD is not available"),
      const SizedBox(height: 10),
      _buildDeliveryRow("assets/Seller_dashboard_images/return_icon.png", "Problem free 7 days return and exchange"),
      const SizedBox(height: 10),
      _buildDeliveryRow("assets/Seller_dashboard_images/delivery_icon.png", "Delivery charge ₹99"),
    ],
  );
}

Widget _buildDeliveryRow(String path, String text) {
  return Row(
    children: [
      Image.asset(path, height: 30),
      const SizedBox(width: 10),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}

class StatItemVendor extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const StatItemVendor({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Icon(icon, size: 18),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}