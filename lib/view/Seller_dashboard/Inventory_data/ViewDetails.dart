import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/BookDetails.dart';
import 'package:http/http.dart' as http;
import 'Customer Photos.dart';
import 'CustomerReviews.dart';
import 'Inventory.dart';

class Viewdetails extends StatefulWidget {
  final Map<String, dynamic> product;
  const Viewdetails({super.key, required this.product});

  @override
  State<Viewdetails> createState() => _ViewdetailsState();
}

class _ViewdetailsState extends State<Viewdetails> {
  String? accessToken;
  late Map<String, dynamic> productDetails;
  List<String> allImageUrls = [];
  bool isLoading = true;
  String bookName = 'hii';
  int bookPrice = 0; // ✅ Use this
  String authorname = "n/A";
  String description = "N/A";
  double? rating;
  String? review;
  Dio dio = Dio();
  List<dynamic> product = [];

  @override
  void initState() {
    super.initState();
    productDetails = widget.product;
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchReviewAndRating();
    await fetchProducts();
  }

  Future<void> fetchReviewAndRating() async {
    final String url =
        'https://admin.uthix.com/api/vendor/review/${productDetails['id']}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      log("📩 API Response Code: ${response.statusCode}");
      log("📩 API Response Headers: ${response.headers}");
      log("📜 API Response Body (Raw): ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        log("✅ Parsed JSON: $data");

        setState(() {
          if (data['reviews']?.isNotEmpty ?? false) {
            rating = (data['reviews'][0]['rating'] as num?)?.toDouble() ?? 0.0;
            review = data['reviews'][0]['review'] ?? "No review available";
          } else {
            rating = 0.0;
            review = "No review available";
          }
        });
      } else {
        log("❌ API Request Failed: ${response.statusCode} - ${response.body}");
        setState(() {
          rating = 0.0;
          review = "No review available";
        });
      }
    } catch (e) {
      log("❌ Network Error: $e");
      setState(() {
        rating = 0.0;
        review = "No review available";
      });
    }
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedaccessToken = prefs.getString("auth_token");

    log("Retrieved acesstoken: $savedaccessToken");

    setState(() {
      accessToken = savedaccessToken ?? "No accesstoken";
    });
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

        log("✅ Saloniiii  Full API Response: ${jsonEncode(jsonResponse)}");

        List<dynamic> fetchedProducts = jsonResponse['products'];

        // Extract all image URLs from all products
        List<String> imageUrls = [];

        for (var product in fetchedProducts) {
          if (product['images'] != null && product['images'].isNotEmpty) {
            for (var image in product['images']) {
              final imageUrl =
                  'https://admin.uthix.com/storage/image/products/${image['image_path']}';
              imageUrls.add(imageUrl);
            }
          }
        }

        log("✅ Total images fetched: ${imageUrls.length}");

        setState(() {
          allImageUrls = imageUrls;
        });
      } else {
        log("❌ Failed to fetch products: ${response.statusCode}");
        log("❌ Response body: ${response.data}");
      }
    } catch (e) {
      log("❌ Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1, // square container (1:1 ratio)
                      ),
                      itemCount: allImageUrls.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 140, // fixed height
                              width: 140, // fixed width
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  allImageUrls[index],
                                  fit: BoxFit
                                      .contain, // scales proportionally, no cropping
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () {
                                  print('Remove image at index $index');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Text description for the item
                  Text(
                    productDetails['title'] ?? 'Product Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "5",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the start
                            children: [
                              Text(
                                productDetails['price'].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFFF6F6F6),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: const Text(
                          //     "6 out of 10 sold",
                          //     style: TextStyle(),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8), // Spacing between elements
                      Container(
                        width: double.infinity, // Full width
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Padding for spacing
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // Center content
                          children: [
                            Text(
                              productDetails['author'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                                width: 4), // Space between text and divider
                            Text(
                              "|",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              productDetails['language'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "|",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "14th edition",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        productDetails['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 15),
                          // Add the existing code below the Divider
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                StatItemVenodr(
                                  title: 'RATING',
                                  value: (rating ?? 0.0).toStringAsFixed(1),
                                  icon: Icons.star, // Show an icon
                                  backgroundColor: Color(0xFFF2F2FD),
                                ),
                                StatItemVenodr(
                                  title: 'ALL BOOKS',
                                  value: productDetails['stock'].toString(),
                                  icon: Icons.book, // Show an icon
                                  backgroundColor: Color(0xFFEFFCFA),
                                ),
                                StatItemVenodr(
                                  title: 'BOOKS SOLD',
                                  value: '20',
                                  icon: Icons.book,
                                  backgroundColor: Color(0xFFEFFCFA),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //Delivery Instruction
                      deliveryInstructions(),

                      SizedBox(
                        height: 20,
                      ),
                      //For Review and Rating
                      reviewAndRating(rating, review),
                      SizedBox(
                        height: 20,
                      ),

                      //Customer Review pages
                      CustomerReview(),
                      SizedBox(height: 10),

                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: OutlinedButton(
                          onPressed: () {
                            print("Button Pressed");
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Edit Details',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviewAndRating(dynamic rating, dynamic review) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Reviews & Ratings',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: 75,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF2B5C74),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (rating ?? 0.0)
                        .toStringAsFixed(1), // Ensure rating is never null
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            review ?? "No review available", // ✅ Handle null reviews
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget CustomerReview() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Builder(
        builder: (BuildContext context) {
          // This is a new, valid context
          return TextButton(
            onPressed: () {
              Navigator.push(
                context, // Use the context from the Builder
                MaterialPageRoute(builder: (context) => CustomerPhotos()),
              );
            },
            child: Text(
              "Customer Photos",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Item $index',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 70,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF2B5C74),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '2 month ago',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Books are in good condition and got them on time, happy with the packaging',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Builder(
                builder: (BuildContext context) {
                  // This is a new, valid context
                  return TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Customerreviews()),
                      );
                    },
                    child: Text(
                      'View all 12 reviews',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 10,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget deliveryInstructions() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/order_outline.png",
          text: "Takes 4 days approx to get delivered",
        ),
        const SizedBox(height: 15),
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/COD_icon.png",
          text: "COD is not available",
        ),
        const SizedBox(height: 15),
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/return_icon.png",
          text: "Problem free 7 days return and exchange",
        ),
        const SizedBox(height: 15),
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/delivery_icon.png",
          text: "Delivery charge ₹99",
        ),
      ],
    ),
  );
}

Widget _buildDeliveryRow({required String imagePath, required String text}) {
  return Row(
    children: [
      Image.asset(imagePath, height: 30),
      const SizedBox(width: 10),
      Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class StatItemVenodr extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? backgroundColor;

  const StatItemVenodr({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          // const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          if (icon != null)
            Icon(
              icon,
              size: 15,
              color: Colors.black87,
            ),
        ],
      ),
    );
  }
}
