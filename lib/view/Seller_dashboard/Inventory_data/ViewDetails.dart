import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/BookDetails.dart';
import 'package:http/http.dart' as http;
import 'Customer Photos.dart';
import 'CustomerReviews.dart';
import 'Inventory.dart';

class Viewdetails extends StatefulWidget {
  final String productTitle;
  final String productId;
  const Viewdetails(
      {super.key, required this.productTitle, required this.productId});

  @override
  State<Viewdetails> createState() => _ViewdetailsState();
}

class _ViewdetailsState extends State<Viewdetails> {
  String? accessToken;
  Map<String, dynamic>? productDetails;
  List<dynamic> productsImages = [];
  bool isLoading = true;
  String bookName = 'hii';
  int bookPrice = 0; // ✅ Use this
  String authorname = "n/A";
  String description = "N/A";
  double? rating;
  String? review;

  @override
  void initState() {
    super.initState();
    log("📦 Received Product ID: ${widget.productId}");
    log("📖 Received Product Title: ${widget.productTitle}");
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchProductDetails();
    await fetchProductAdditionalDetails();
    await fetchReviewAndRating();
  }

  Future<void> fetchReviewAndRating() async {
    final String url =
        'https://admin.uthix.com/api/vendor/review/${widget.productId}';

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

  Future<void> fetchProductAdditionalDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      bookName = prefs.getString('book_title_${widget.productTitle}') ??
          'Unknown Title';
      authorname = prefs.getString('book_author_${widget.productTitle}') ??
          'Unknown Author';
      description =
          prefs.getString('book_description_${widget.productTitle}') ??
              'No description available';

      bookPrice = prefs.getInt('book_price_${widget.productTitle}') ?? 0;
    });

    log("📖 Book Details Loaded: $bookName, Price: $bookPrice");
  }

  Future<void> fetchProductDetails() async {
    log("🔍 Fetching product details for Title: ${widget.productTitle}");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String? storedThumbnail =
          prefs.getString('local_thumbnail_${widget.productTitle}');

      List<String>? storedImages =
          prefs.getStringList('local_images_${widget.productTitle}');

      setState(() {
        productsImages = storedImages ?? [];
        isLoading = false;
      });

      log("📌 Retrieved Images for ${widget.productTitle}: $productsImages");
    } catch (e) {
      log("❌ Error fetching product details: $e");
      setState(() => isLoading = false);
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
                  // Image carousel or grid view
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.55, // Adjust space between images
                      ),
                      itemCount: productsImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: productsImages[index]
                                          .startsWith("http")
                                      ? Image.network(
                                          productsImages[index], // Server image
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : Image.file(
                                          File(productsImages[
                                              index]), // Local image
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey),
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        productsImages.removeAt(
                                            index); // Remove image on tap
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.close,
                                          size: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text description for the item
                  Text(
                    bookName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Hard Cover",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
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
                          fontFamily: 'Urbanist',
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
                                bookPrice.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "6 out of 10 sold",
                              style: TextStyle(),
                            ),
                          ),
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
                              authorname,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Urbanist',
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
                              "January",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Urbanist',
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
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Urbanist',
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
                                  value: '50',
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
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
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
              fontFamily: 'Urbanist',
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
                fontFamily: 'Urbanist',
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
              fontFamily: 'Urbanist',
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
                  fontFamily: 'Urbanist',
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
              fontFamily: 'Urbanist',
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
                        fontFamily: 'Urbanist',
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
          fontFamily: 'Urbanist',
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
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          // const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Urbanist',
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
