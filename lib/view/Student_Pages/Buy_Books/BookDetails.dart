import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomerPhotosPage.dart';
import 'CustomerReviewPage.dart';
import 'Wishlist.dart';
import 'StudentCart.dart';
import 'StudentSearch.dart';

class Bookdetails extends StatefulWidget {
  final int productId;
  const Bookdetails({Key? key, required this.productId}) : super(key: key);

  @override
  State<Bookdetails> createState() => _BookdetailsState();
}

class _BookdetailsState extends State<Bookdetails> {
  late Future<Map<String, dynamic>> productFuture;
  final Dio _dio = Dio();
  Map<String, dynamic>? _productData; // Save product details
  bool _isWishlisted = false;         // Wishlist state (unused in bottom nav now)

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
    loadWishlistStatus();
  }

  /// Helper function to create AppBar icon buttons.
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(icon, color: Colors.black, size: 25),
          onPressed: onTap,
        ),
      ),
    );
  }

  /// Fetch product details from the API.
  Future<Map<String, dynamic>> fetchProduct() async {
    try {
      final response = await _dio.get(
          "https://admin.uthix.com/api/products/view/${widget.productId}");
      if (response.statusCode == 200) {
        final product = response.data["product"];
        setState(() {
          _productData = product;
        });
        return product;
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Failed to load product: $e");
    }
  }

  /// Load wishlist status from SharedPreferences.
  Future<void> loadWishlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wishlist = prefs.getStringList("wishlist_products");
    if (wishlist != null && wishlist.contains(widget.productId.toString())) {
      setState(() {
        _isWishlisted = true;
      });
    }
  }

  /// (Optional) Wishlist functions remain here if needed elsewhere.
  Future<void> addToWishlist(Map<String, dynamic> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to add product to wishlist.")),
      );
      return;
    }
    String imageUrl;
    if (product["first_image"] != null &&
        product["first_image"]["image_path"] != null) {
      imageUrl =
      "https://admin.uthix.com/storage/image/products/${product["first_image"]["image_path"]}";
    } else {
      imageUrl = "https://via.placeholder.com/150";
    }
    final data = {
      "product_id": product["id"],
      "title": product["title"] ?? "No Title",
      "image": imageUrl,
      "rating": product["rating"]?.toString() ?? "N/A",
      "author": product["author"] ?? "Unknown Author",
      "price": product["price"]?.toString() ?? "N/A",
    };

    try {
      final response = await Dio().post(
        "https://admin.uthix.com/api/wishlist",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<String> wishlist = prefs.getStringList("wishlist_products") ?? [];
        if (!wishlist.contains(product["id"].toString())) {
          wishlist.add(product["id"].toString());
          await prefs.setStringList("wishlist_products", wishlist);
        }
        setState(() {
          _isWishlisted = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added to wishlist!")),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Wishlist()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to wishlist: ${response.data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding to wishlist: $e")));
    }
  }

  Future<void> removeFromWishlist(Map<String, dynamic> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to remove product from wishlist.")),
      );
      return;
    }
    try {
      final response = await Dio().delete(
        "https://admin.uthix.com/api/wishlist/${product["id"]}",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        List<String> wishlist = prefs.getStringList("wishlist_products") ?? [];
        wishlist.remove(product["id"].toString());
        await prefs.setStringList("wishlist_products", wishlist);
        setState(() {
          _isWishlisted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product removed from wishlist.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to remove from wishlist: ${response.data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error removing from wishlist: $e")));
    }
  }

  /// Add product to cart via API.
  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please login to add product to cart.")));
      return;
    }
    final product = _productData;
    if (product == null) return;
    double price = product["discount_price"] != null
        ? (product["discount_price"] as num).toDouble()
        : (product["price"] as num).toDouble();
    final requestData = {
      "product_id": product["id"],
      "quantity": 1,
      "price": price,
    };

    try {
      final response = await Dio().post(
        "https://admin.uthix.com/api/add-to-cart",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        data: requestData,
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data["status"] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Product added to cart!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to add to cart: ${response.data["message"] ?? "Unknown error"}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding to cart: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 119, 78, 78),
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _iconButton(Icons.search,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentSearch(categoryId: null)))),
          _iconButton(
              Icons.favorite_border,
                  () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Wishlist()))),
          _iconButton(
              Icons.shopping_bag_outlined,
                  () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Studentcart(cartItems: [])))),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2B5C74))));
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: 14)));
          } else if (snapshot.hasData) {
            var product = snapshot.data!;
            List<dynamic> imagesData = product["images"] ?? [];
            List<String> images = imagesData.map((img) {
              return "https://admin.uthix.com/storage/image/products/${img["image_path"]}";
            }).toList();
            List<dynamic> reviews = product["reviews"] ?? [];
            List<dynamic> customerPhotos = product["customer_photos"] ?? [];
            String deliveryText = product["delivery_instructions"] ??
                "Please ensure that someone is available to receive the package at the provided address.";

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel.
                    SizedBox(
                      height: 200.h,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 0.55,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Center(
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: 0.5.sw,
                                height: 200.h,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 50.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // Title and ISBN.
                    Text(product["title"] ?? "No title", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(product["isbn"] ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                    SizedBox(height: 8.h),
                    // Rating.
                    if (product.containsKey("rating") && product["rating"] != null)
                      Row(
                        children: [
                          Text(product["rating"].toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(width: 5.w),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                        ],
                      ),
                    SizedBox(height: 5.h),
                    // Price, language, pages, author info.
                    Row(
                      children: [
                        Text(product["price"].toString(), style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("by ${product["author"] ?? ""}", style: TextStyle(fontSize: 14, color: const Color(0xFF605F5F))),
                          SizedBox(width: 4.w),
                          Text("|", style: TextStyle(fontSize: 16, color: const Color(0xFF605F5F), fontWeight: FontWeight.bold)),
                          SizedBox(width: 10.w),
                          Text(product["language"] ?? "", style: TextStyle(fontSize: 14, color: const Color(0xFF605F5F))),
                          SizedBox(width: 4.w),
                          Text("|", style: TextStyle(fontSize: 16, color: const Color(0xFF605F5F), fontWeight: FontWeight.bold)),
                          SizedBox(width: 10.w),
                          Text("${product["pages"]} pages", style: TextStyle(fontSize: 14, color: const Color(0xFF605F5F))),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Description.
                    Text(product["description"] ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 20.h),
                    // Delivery Instructions.
                    deliveryInstructions(deliveryText),
                    SizedBox(height: 20.h),
                    // Optionally display Reviews & Customer Photos.
                    if (reviews.isNotEmpty || customerPhotos.isNotEmpty) ...[
                      if (reviews.isNotEmpty) ...[
                        reviewAndRating(product["rating"]?.toString() ?? "N/A", reviews.length),
                        SizedBox(height: 10.h),
                      ],
                      if (customerPhotos.isNotEmpty) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCustomerPhotos()));
                          },
                          child: Text("Customer Photos", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 8.h),
                      ],
                      if (reviews.isNotEmpty) ...[
                        CustomerReview(reviews: reviews),
                        SizedBox(height: 10.h),
                      ],
                    ],
                    SizedBox(height: 80.h), // Extra spacing for bottom bar.
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text("No data available", style: TextStyle(fontSize: 18)));
          }
        },
      ),
      // Bottom Navigation Bar with only the "Add to Bag" button.
      bottomNavigationBar: Container(
        height: 70.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: ElevatedButton.icon(
          onPressed: () {
            addToCart();
          },
          icon: Icon(Icons.shopping_bag_outlined, size: 20.sp, color: Colors.white),
          label: Text(
            'Add to Bag',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF305C78),
            minimumSize: Size(double.infinity, 50), // Makes the button full width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ),

    );
  }
}

/// Delivery Instructions widget.
Widget deliveryInstructions(String instructions) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Delivery Instructions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.h),
        Text(instructions, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

/// Reviews & Ratings summary widget.
Widget reviewAndRating(String rating, int numberOfReviews) {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews & Ratings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.h),
        Row(
          children: [
            Container(
              width: 70.w,
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xFF2B5C74),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(rating,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text('$numberOfReviews Ratings & ${numberOfReviews > 0 ? (numberOfReviews / 2).floor() : 0} reviews',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}

/// Widget for Customer Reviews.
class CustomerReview extends StatelessWidget {
  final List<dynamic> reviews;
  const CustomerReview({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          if (reviews.isNotEmpty)
            Row(
              children: [
                Container(
                  width: 70.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFF2B5C74),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text('3',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text('2 months ago', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          SizedBox(height: 8.h),
          Text('Books are in good condition and I received them on time. Packaging was excellent.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 10.h),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentPageCustomerReview()));
                },
                child: Text('View all ${reviews.length} reviews',
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
              ),
              Icon(Icons.arrow_forward_ios, size: 10.sp),
            ],
          ),
        ],
      ),
    );
  }
}
