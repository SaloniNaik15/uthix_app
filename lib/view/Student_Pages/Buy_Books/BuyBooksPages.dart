import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  void initState() {
    super.initState();
    fetchProducts(widget.categoryId);
  }

  // 🔹 Fetch Products API Call
  Future<void> fetchProducts(int categoryId) async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/products',
        queryParameters: {"category_id": categoryId},
      );

      print("Products Response: ${response.data}");

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
  Future<void> addToCart(BuildContext context, Map<String, dynamic> product, int quantity) async {
    const String token = "9|BQsNwAXNQ9dGJfTdRg0gL2pPLp0BTcTG6aH4y83k49ae7d64";
    const String apiUrl = "https://admin.uthix.com/api/add-to-cart";

    try {
      if (product["id"] == null || product["price"] == null) {
        print("Error: Missing required fields");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Missing product details!")),
        );
        return;
      }

      final requestData = {
        "product_id": product["id"],
        "quantity": quantity,
        "price": product["price"],
      };

      print("Sending Request Data: $requestData");

      // 🔹 Send API request
      final response = await Dio().post(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        data: requestData,
      );

      print("API Response: ${response.data}");

      if (response.statusCode == 201 && response.data["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added to cart!")),
        );

        // Navigate to StudentCart Page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Studentcart(cartItems: response.data["cart_items"] ?? []),
        //   ),
        // );
      } else {
        print("API Error: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: ${response.data['message'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      print(" API Exception: $e");
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _iconButton(
              Icons.search,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentSearch()))),
          _iconButton(
              Icons.favorite_border,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Wishlist()))),
          _iconButton(
              Icons.shopping_bag_outlined,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Studentcart(cartItems: [],)))),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text("No products available."))
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Products",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text("${products.length} Items",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 10),
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

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
            icon: Icon(icon, color: Colors.black, size: 20), onPressed: onTap),
      ),
    );
  }
}

class SortByButton extends StatelessWidget {
  const SortByButton({super.key});

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: const Text("Sort by",
                style: TextStyle(fontSize: 18,fontFamily: 'Urbanist', fontWeight: FontWeight.w500)),
          ),
          const Divider(),
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
      title: Text(title, style: const TextStyle(fontSize: 16,fontFamily: 'Urbanist',)),
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSortOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ]),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_vert, size: 18, color: Colors.black54),
            SizedBox(width: 8),
            Text("Sort by",
                style: TextStyle(fontSize: 16, color: Colors.black)),
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
    super.key,
    required this.books,
    required this.addToCart,
  });

  @override
  _BookItemsListState createState() => _BookItemsListState();
}


class _BookItemsListState extends State<BookItemsList> {
  Set<int> wishlist = {};

  Future<void> addToWishlist(BuildContext context, Map<String, dynamic> book) async {
    final String token = "9|BQsNwAXNQ9dGJfTdRg0gL2pPLp0BTcTG6aH4y83k49ae7d64";

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
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          isInWishlist ? wishlist.remove(book['id']) : wishlist.add(book['id']);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isInWishlist ? "Book removed from wishlist!" : "Book added to wishlist!",
            ),
            backgroundColor: isInWishlist ? Colors.red : Colors.green,
          ),
        );
      } else {
        throw Exception("Failed to update wishlist. Response: ${response.data}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
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
                        MaterialPageRoute(builder: (context) => Bookdetails(product: book)),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Book Image with Rating
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
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
                                child: Image.network(
                                  imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        rating,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Book Title
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Author Name
                        Text(
                          "Author: $author",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Book Price
                        Text(
                          "₹$price",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Wishlist and Add to Cart Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isInWishlist ? Icons.favorite : Icons.favorite_border,
                                color: isInWishlist ? Color(0xFF2B5C74) : Color(0xFF2B5C74),
                              ),
                              onPressed: () => addToWishlist(context, book),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                int quantity = 1;

                                if (book.isNotEmpty) {
                                  await widget.addToCart(context, book, quantity);
                                } else {
                                  print("Error: Book data is empty!");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Book data is missing!")),
                                  );
                                }
                              },
                              label: const Text('Add to Bag', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2B5C74),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.white),
                            ),



                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
