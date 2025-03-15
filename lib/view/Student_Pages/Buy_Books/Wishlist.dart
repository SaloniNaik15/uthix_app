import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/start_login.dart';
import 'BookDetails.dart';
import 'StudentCart.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int selectedIndex = 0;

  final List<String> filters = [
    'All',
    'Oldest',
    'Science',
    'Maths',
    'Practical',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wishlist",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Studentcart(
                    cartItems: [],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Filter Buttons
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: selectedIndex == index
                          ? const Color(0xFF2B5C74)
                          : Colors.transparent,
                    ),
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color:
                            selectedIndex == index ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.grey, thickness: 1),
          const Expanded(child: BookList()),
        ],
      ),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final Dio _dio = Dio();
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  String? authToken; // Store token

  @override
  void initState() {
    super.initState();
    loadAuthToken();
    fetchBooks();
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Authentication failed. Please login again.")),
      );
      return;
    }

    setState(() {
      authToken = token;
    });

    fetchBooks(); // Fetch books after loading the token
  }

  Future<void> fetchBooks() async {
    if (authToken == null || authToken!.isEmpty) {
      print("⛔ Auth Token is missing!");
      return;
    }

    try {
      final response = await _dio.get(
        'https://admin.uthix.com/api/wishlist',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // ✅ Dynamic Token
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> wishlistItems = response.data['wishlists'] ?? [];
        final String imageBaseUrl = response.data['image_base_url'] ??
            'https://admin.uthix.com/storage/image/products/';

        List<Map<String, dynamic>> fetchedBooks = wishlistItems.map((item) {
          final product = item['product'] ?? {}; // Get the product object
          final firstImage = product['first_image']; // Get first_image object

          return {
            'id': product['id'],
            'title': product['title'] ?? 'Unknown Title',
            'image': (firstImage != null && firstImage['image_path'] != null)
                ? "$imageBaseUrl${firstImage['image_path']}"
                : "https://via.placeholder.com/150", // Fallback image
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
        handle401Error(); // Logout if token expired
      }
    } catch (e) {
      print('⛔ Error fetching books: $e');
      setState(() => isLoading = false);
    }
  }

  // ✅ Handle 401 Unauthorized Error (Token Expired)
  Future<void> handle401Error() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Clear expired token
    await prefs.remove('user_role');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session expired. Please log in again.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => StartLogin()), // Redirect to login
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : books.isEmpty
            ? const Center(child: Text("No books found in wishlist"))
            : Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
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
                            builder: (context) => Bookdetails(
                              productId: book['id'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Book Image
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  book['image'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        book['rating']?.toString() ?? "N/A",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Book Title
                          Text(
                            book['title'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          // Book Price
                          Text(
                            "₹${book['price']}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Move to Bag Button
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Studentcart(
                                    cartItems: [],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_bag_outlined,
                                size: 16),
                            label: const Text('Move to Bag'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF605F5F),
                              side: const BorderSide(color: Color(0xFFAFAFAF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
  }
}
