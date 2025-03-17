import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'BookDetails.dart';
import 'StudentCart.dart';
import 'StudentSearch.dart';
import 'Wishlist.dart';

class Buybookspages extends StatefulWidget {
  final int categoryId;

  const Buybookspages({super.key, required this.categoryId});

  @override
  State<Buybookspages> createState() => _BuybookspagesState();
}

class _BuybookspagesState extends State<Buybookspages> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  final Dio dio = Dio();
  String? authToken; // Store token

  @override
  void initState() {
    super.initState();
    loadAuthToken();
    fetchProducts(widget.categoryId);
  }

  // ✅ Fetch token from SharedPreferences
  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('auth_token'); // Retrieve token
    });

    if (authToken != null) {
      fetchProducts(widget.categoryId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated. Please login.")),
      );
    }
  }

  // 🔹 Fetch Products API Call
  Future<void> fetchProducts(int categoryId) async {
    if (authToken == null) return;

    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/products',
        queryParameters: {"category_id": categoryId},
        options: Options(
          headers: {"Authorization": "Bearer $authToken"}, // Use dynamic token
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          products =
          List<Map<String, dynamic>>.from(response.data['products'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //  Add to Cart API Call
  Future<void> addToCart(
      BuildContext context, Map<String, dynamic> product, int quantity) async {
    if (authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Authentication failed. Please login again.")),
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

      final response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken", // Use dynamic token
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
          SnackBar(
            content: Text(
                "Failed to add to cart: ${response.data['message'] ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      print("API Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")),
      );
    }
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
            icon: Icon(icon, color: Colors.black, size: 20.sp),
            onPressed: onTap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that ScreenUtil is initialized in main.dart
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: const Color(0xFF605F5F), size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _iconButton(
              Icons.search,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentSearch(categoryId: null)))),
          _iconButton(Icons.favorite_border,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => Wishlist()))),
          _iconButton(
              Icons.shopping_bag_outlined,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Studentcart(cartItems: [])))),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(
          child: Text("No products available.",
              style: TextStyle(fontSize: 14.sp)))
          : Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Products",
                style: TextStyle(
                    fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 5.h),
            Text("${products.length} Items",
                style: TextStyle(
                    fontSize: 14.sp, color: Colors.black87)),
            SizedBox(height: 10.h),
            Expanded(
              child: BookItemsList(
                books: products,
                addToCart: addToCart,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SortByButton(),
    );
  }
}

class SortByButton extends StatelessWidget {
  const SortByButton({super.key});

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text("Sort by",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500)),
          ),
          Divider(),
          _sortOption(context, "Relevance"),
          _sortOption(context, "Discount"),
          _sortOption(context, "Price: High to Low"),
          _sortOption(context, "Price: Low to High"),
          _sortOption(context, "Customer Top Rated"),
          _sortOption(context, "New Arrival"),
        ],
      ),
    );
  }

  Widget _sortOption(BuildContext context, String title) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Urbanist',
          )),
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSortOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_vert, size: 18.sp, color: Colors.black54),
            SizedBox(width: 8.w),
            Text("Sort by",
                style: TextStyle(fontSize: 16.sp, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class BookItemsList extends StatefulWidget {
  final List<Map<String, dynamic>> books;
  final Future<void> Function(BuildContext, Map<String, dynamic>, int) addToCart;

  const BookItemsList({
    Key? key,
    required this.books,
    required this.addToCart,
  }) : super(key: key);

  @override
  _BookItemsListState createState() => _BookItemsListState();
}

class _BookItemsListState extends State<BookItemsList> {
  Set<int> wishlist = {};

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  // Load the wishlist from persistent storage.
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? wishlistStrings = prefs.getStringList("wishlist");
    if (wishlistStrings != null) {
      setState(() {
        wishlist = wishlistStrings.map((e) => int.tryParse(e) ?? 0).toSet();
      });
    }
  }

  // Persist the wishlist state.
  Future<void> updateWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlistStrings = wishlist.map((id) => id.toString()).toList();
    await prefs.setStringList("wishlist", wishlistStrings);
  }

  Future<void> addToWishlist(
      BuildContext context, Map<String, dynamic> book) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Authentication failed. Please login again.")),
      );
      return;
    }

    try {
      bool isInWishlist = wishlist.contains(book['id']);
      final String imageUrl = book['first_image'] != null
          ? 'https://admin.uthix.com/storage/image/products/${book['first_image']['image_path']}'
          : "https://via.placeholder.com/150";

      final response = await Dio().post(
        'https://admin.uthix.com/api/wishlist',
        data: {
          'product_id': book['id'],
          'title': book['title'],
          'image': imageUrl,
          'rating': book['rating'],
          'author': book['author'],
          'price': book['price'],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // ✅ Dynamic Token
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (isInWishlist) {
            wishlist.remove(book['id']);
          } else {
            wishlist.add(book['id']);
          }
        });
        await updateWishlist();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isInWishlist
                ? "Book removed from wishlist!"
                : "Book added to wishlist!"),
            backgroundColor: isInWishlist
                ? const Color(0xFF2B5C74)
                : const Color(0xFF2B5C50),
          ),
        );
      } else if (response.statusCode == 401) {
        print("⛔ Unauthorized: Token is invalid or expired.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Session expired. Please log in again.")),
        );
      } else {
        throw Exception(
            "Failed to update wishlist. Response: ${response.data}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic aspect ratio for grid items.
    final double horizontalPadding = 40.w;
    final double itemWidth =
        (MediaQuery.of(context).size.width - horizontalPadding) / 2;
    // Adjust the multiplier as needed (1.7 in this case)
    final double itemHeight = itemWidth * 1.8;
    final double aspectRatio = itemWidth / itemHeight;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: aspectRatio,
          ),
          itemCount: widget.books.length,
          itemBuilder: (context, index) {
            final book = widget.books[index];
            final bool isInWishlist = wishlist.contains(book['id']);
            final String title = book['title'] ?? "No Title";
            final String author = book['author'] ?? "Unknown Author";
            final String price = book['price']?.toString() ?? "0";
            final String rating = book['rating']?.toString() ?? "N/A";
            final String imageUrl = book['first_image'] != null
                ? 'https://admin.uthix.com/storage/image/products/${book['first_image']['image_path']}'
                : "https://via.placeholder.com/150";

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Bookdetails(productId: book['id']),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product image with rating overlay.
                  Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 2.w),
                      borderRadius: BorderRadius.circular(10.r),
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
                          borderRadius: BorderRadius.circular(8.r),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 150.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 150.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 150.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 100.sp,
                                color: Colors.grey,
                              ),
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
                                  rating,
                                  style: TextStyle(
                                    fontSize: 12.sp,
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
                  ),
                  SizedBox(height: 4.h),
                  // Product Title.
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Author.
                  Text(
                    "Author: $author",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Price.
                  Text(
                    "₹$price",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  //SizedBox(height: 4.h),
                  // Wishlist and Add to Bag buttons.
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFF2B5C74),
                          size: 25.sp,
                        ),
                        onPressed: () => addToWishlist(context, book),
                      ),
                      //SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            int quantity = 1;
                            if (book.isNotEmpty) {
                              await widget.addToCart(context, book, quantity);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Book data is missing!")),
                              );
                            }
                          },
                          icon: Icon(Icons.shopping_bag_outlined, size: 16.sp, color: Colors.white),
                          label: Text('Add to Bag',
                              style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B5C74),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ],
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


