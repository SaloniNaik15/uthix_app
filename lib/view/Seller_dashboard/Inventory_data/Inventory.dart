import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:uthix_app/view/Seller_dashboard/Inventory_data/ViewDetails.dart';

class InventoryData extends StatefulWidget {
  const InventoryData({super.key});

  @override
  State<InventoryData> createState() => _InventoryDataState();
}

class _InventoryDataState extends State<InventoryData> {
  int selectedIndex = -1;
  List<dynamic> products = []; // To store fetched products
  String? accessToken;
  String? productId;
  String? bookTitle;

  final List<String> filters = [
    'All',
    'Textbooks',
    'Notebooks',
    'Stationary',
    'Lab Equipment',
    'Book Marks'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchLatestProductId();

    await fetchProducts();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedaccessToken = prefs.getString("userToken");

    log("Retrieved acesstoken: $savedaccessToken");

    setState(() {
      accessToken = savedaccessToken ?? "No accesstoken";
    });
  }

  /// Fetch the latest book title stored in SharedPreferences
  Future<String?> getLatestBookTitle() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys(); // Get all stored keys

    List<String> bookTitles = [];

    // Extract book titles from keys
    for (String key in keys) {
      if (key.startsWith("book_title_")) {
        String? bookTitle = prefs.getString(key);
        if (bookTitle != null) {
          bookTitles.add(bookTitle);
        }
      }
    }

    if (bookTitles.isEmpty) {
      log("❌ No book titles found in SharedPreferences");
      return null;
    }

    // Assuming the last added title is the latest
    String latestBookTitle = bookTitles.last;
    log("✅ Latest Book Title Retrieved: $latestBookTitle");

    return latestBookTitle;
  }

  /// Get product ID using book title
  Future<String?> getProductIdByTitle(String bookTitle) async {
    final prefs = await SharedPreferences.getInstance();
    String key = "product_id_$bookTitle";
    String? productId = prefs.getString(key);

    if (productId == null) {
      log("❌ No Product ID found for book title: $bookTitle");
      return null;
    }

    log("✅ Retrieved Product ID for '$bookTitle': $productId");
    return productId;
  }

  /// Fetch latest product ID dynamically
  String? latestBookTitle;
  String? latestProductId;

  Future<void> fetchLatestProductId() async {
    latestBookTitle = await getLatestBookTitle(); // ✅ Store in variable
    if (latestBookTitle != null) {
      latestProductId =
          await getProductIdByTitle(latestBookTitle!); // ✅ Store in variable
      log("📝 Stored Latest Product ID: ${latestProductId ?? 'Not Found'}");
    } else {
      log("❌ Could not fetch latest Product ID");
    }
  }

  Future<void> fetchProducts() async {
    final url = 'https://admin.uthix.com/api/get/vendor/products';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          products = (data['products'] as List).map((item) {
            String bookTitle = item['title'] ?? 'unknown_title';
            int bookPrice = (item['price'] is int)
                ? item['price']
                : int.tryParse(item['price']?.toString() ?? '0') ?? 0;

            String bookDescription = item['description'] ?? 'No description';
            String bookAuthor = item['author'] ?? 'Unknown author';

            // ✅ Store Book Details in SharedPreferences
            prefs.setString('book_title_$bookTitle', bookTitle);
            prefs.setInt('book_price_$bookTitle', bookPrice);
            prefs.setString('book_description_$bookTitle', bookDescription);
            prefs.setString('book_author_$bookTitle', bookAuthor);

            // ✅ Log to check stored values
            log("📌 Stored in SharedPreferences:");
            log("   🔹 Title: $bookTitle");
            log("   🔹 Price: $bookPrice");
            log("   🔹 Description: $bookDescription");
            log("   🔹 Author: $bookAuthor");

            // ✅ Retrieve stored local & server thumbnail from SharedPreferences
            String? localThumbnail =
                prefs.getString('local_thumbnail_$bookTitle');
            String? serverThumbnail = item['thumbnail_img'];
            String? storedServerThumbnail =
                prefs.getString('server_thumbnail_$bookTitle');

            // ✅ Prefer Local Image first, then Server Image
            String finalThumbnail = '';
            if (localThumbnail != null && localThumbnail.isNotEmpty) {
              finalThumbnail = localThumbnail; // Use local image if exists
            } else if (serverThumbnail != null && serverThumbnail.isNotEmpty) {
              finalThumbnail =
                  "https://admin.uthix.com/uploads/$serverThumbnail"; // Use server image
            } else if (storedServerThumbnail != null &&
                storedServerThumbnail.isNotEmpty) {
              finalThumbnail =
                  storedServerThumbnail; // Use stored server image if API fails
            }

            // ✅ Retrieve stored local & server images
            List<String>? localImages =
                prefs.getStringList('local_images_$bookTitle');
            List<String> serverImages = [];
            if (item['images'] != null) {
              serverImages = (item['images'] as List)
                  .map<String>((img) =>
                      "https://admin.uthix.com/uploads/${img['image_path']}")
                  .toList();
            }

            // ✅ If local images exist, use them instead of server images
            List<String> finalImages = [];
            if (localImages != null && localImages.isNotEmpty) {
              finalImages = localImages;
            } else if (serverImages.isNotEmpty) {
              finalImages = serverImages;
            }

            log("📌 Final Thumbnail for $bookTitle: $finalThumbnail");
            log("📌 Final Images for $bookTitle: $finalImages");

            return {
              'title': bookTitle,
              'price': bookPrice,
              'description': bookDescription,
              'author': bookAuthor,
              'thumbnail_img':
                  finalThumbnail, // ✅ Uses local first, then server
              'images': finalImages, // ✅ Uses local first, then server
            };
          }).toList();
        });

        print("✅ Products Updated with Local & Server Images!");
      } else {
        print('❌ Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "My Catalogue",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '200 Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 15),
            // Filters and other UI components

            // Display products once fetched
            Column(
              children: [
                if (products.isEmpty)
                  const Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                else
                  BookList(
                      products: products,
                      latestProductId: latestProductId,
                      latestBookTitle:
                          latestBookTitle), // Pass products to the BookList widget
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BookList extends StatelessWidget {
  final List<dynamic> products; // List to store fetched products
  String? latestProductId;
  String? latestBookTitle;

  BookList(
      {Key? key,
      required this.products,
      required this.latestProductId,
      required this.latestBookTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            childAspectRatio: 0.55,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return GestureDetector(
              onTap: () {
                print('Tapped on: ${product['title']}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Card with Rating (Optional, based on your API data)
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: product['thumbnail_img'] != null &&
                                  product['thumbnail_img'].isNotEmpty
                              ? (product['thumbnail_img'].startsWith("/") ||
                                      product['thumbnail_img']
                                          .contains("data/user"))
                                  // ✅ Local Image
                                  ? Image.file(
                                      File(product['thumbnail_img']),
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    )
                                  // ✅ Server Image
                                  : Image.network(
                                      product['thumbnail_img']
                                              .startsWith("http")
                                          ? product['thumbnail_img']
                                          : "https://admin.uthix.com/uploads/${product['thumbnail_img']}",
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    )
                              // ✅ Placeholder if no image
                              : Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Book Title
                  Container(
                    height: 40,
                    child: Text(
                      product['title'] ?? 'No title',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Book Price
                  Text(
                    '\$${product['price'] ?? '0'}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // View Details Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        // ✅ Make it async

                        log("📖 Title: ${latestBookTitle} (${latestBookTitle.runtimeType})");
                        log("🆔 Product ID: ${latestProductId} (${latestProductId.runtimeType})");

                        if (latestProductId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Viewdetails(
                                productTitle:
                                    latestBookTitle ?? "Unknown Title",
                                productId: latestProductId?.toString() ??
                                    "N/A", // Convert to String
                              ),
                            ),
                          );
                        } else {
                          log("❌ Could not fetch latest Product ID");
                        }
                      },
                      icon: Icon(Icons.info),
                      label: Text("View Details"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
