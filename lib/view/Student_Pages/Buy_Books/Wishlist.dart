import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../homeRegistration/new_login.dart';
import 'BookDetails.dart';
import 'StudentCart.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int selectedIndex = 0;
  final List<String> filters = ['All', 'Oldest', 'Science', 'Maths', 'Practical'];
  String? authToken;
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadAuthToken();
    if (authToken != null && authToken!.isNotEmpty) {
      await fetchBooks();
    }
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication failed. Please login again.")),
      );
      return;
    }
    setState(() {
      authToken = token;
    });
  }

  Future<void> fetchBooks() async {
    if (authToken == null || authToken!.isEmpty) return;
    try {
      final response = await _dio.get(
        'https://admin.uthix.com/api/wishlist',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> wishlistItems = response.data['wishlists'] ?? [];
        final String imageBaseUrl = response.data['image_base_url'] ??
            'https://admin.uthix.com/storage/image/products/';
        List<Map<String, dynamic>> fetchedBooks = wishlistItems.map((item) {
          final product = item['product'] ?? {};
          final firstImage = product['first_image'];
          return {
            'id': product['id'],
            'title': product['title'] ?? 'Unknown Title',
            'image': (firstImage != null && firstImage['image_path'] != null)
                ? "$imageBaseUrl${firstImage['image_path']}"
                : "https://via.placeholder.com/150",
            'rating': product['rating']?.toString() ?? 'N/A',
            'price': product['price']?.toString() ?? 'N/A',
            'author': product['author'] ?? 'Unknown Author',
          };
        }).toList();

        setState(() {
          books = fetchedBooks;
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        await handle401Error();
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handle401Error() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session expired. Please log in again.")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NewLogin()),
    );
  }

  /// Add the selected book to cart using the API.
  Future<void> addToCart(BuildContext context, Map<String, dynamic> product, int quantity) async {
    if (authToken == null || authToken!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication failed. Please login again.")),
      );
      return;
    }
    const String apiUrl = "https://admin.uthix.com/api/add-to-cart";
    try {
      final requestData = {
        "product_id": product["id"],
        "quantity": quantity,
        "price": product["price"],
      };
      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        ),
        data: requestData,
      );
      if (response.statusCode == 201 && response.data["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added to cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: ${response.data['message'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      print("API Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF605F5F), size: 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wishlist",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 25),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Studentcart(cartItems: [])),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          // Filter Buttons
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;
                    // You can add filter functionality here based on the filter selected.
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.r),
                      color: selectedIndex == index ? const Color(0xFF2B5C74) : Colors.transparent,
                    ),
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: selectedIndex == index ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey, thickness: 1),
          Expanded(child: buildBookGrid()),
        ],
      ),
    );
  }

  Widget buildBookGrid() {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
      ),
    )
        : books.isEmpty
        ? const Center(child: Text("No books found in wishlist"))
        : Padding(
      padding: EdgeInsets.all(20.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.6,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Bookdetails(productId: book['id']),
                ),
              );
            },
            child: buildBookItem(book),
          );
        },
      ),
    );
  }

  Widget buildBookItem(Map<String, dynamic> book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Book Image with rating overlay.
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: book['image'],
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150.h,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
                  )),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150.h,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported, size: 100.sp, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 5.h,
              left: 5.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book['rating']?.toString() ?? "N/A",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        // Book Title
        Text(
          book['title'],
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5.h),
        // Book Price
        Text(
          "₹${book['price']}",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5.h),
        // "Move to Bag" Button
        OutlinedButton.icon(
          onPressed: () {
            addToCart(context, book, 1);
          },
          icon: Icon(Icons.shopping_bag_outlined, size: 16.sp, color: Colors.black),
          label: Text('Move to Bag',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF605F5F),
            side: const BorderSide(color: Color(0xFFAFAFAF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ],
    );
  }
}
