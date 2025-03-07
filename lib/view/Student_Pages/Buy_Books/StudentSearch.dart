import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StudentSearch extends StatefulWidget {
  const StudentSearch({super.key});

  @override
  State<StudentSearch> createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> allProducts = []; // Store all products
  List<dynamic> searchResults = []; // Filtered results
  bool isLoading = false;
  int selectedIndex = 0;

  final List<String> filters = [
    'All',
    'Subject',
    'Books',
    'Stationary',
    'Lab Equipments'
  ];

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final dio = Dio();
      final response =
          await dio.get('https://admin.uthix.com/api/categories/2/products');

      if (response.statusCode == 200 && response.data.containsKey('products')) {
        setState(() {
          allProducts = response.data['products']; // Store all products
          searchResults = allProducts; // Show all products initially
        });
      } else {
        setState(() => searchResults = []);
      }
    } catch (e) {
      setState(() => searchResults = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void searchCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = allProducts;
        return;
      }

      final queryLower = query.toLowerCase();
      searchResults = allProducts.where((product) {
        final title = (product['title'] ?? '').toLowerCase();
        final author = (product['author'] ?? '').toLowerCase();
        final language = (product['language'] ?? '').toLowerCase();
        return title.contains(queryLower) ||
            author.contains(queryLower) ||
            language.contains(queryLower);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Widget buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  searchController.text = filters[index];
                  searchCategories(filters[index]);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: selectedIndex == index
                      ? const Color(0xFF2B5C74)
                      : Colors.transparent,
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.grey,
                    fontWeight: selectedIndex == index
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return Expanded(
      child: searchResults.isEmpty
          ? const Center(
              child: Text("No results found",
                  style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final product = searchResults[index];

                return Card(
                  color: const Color(0xFFD6D6D6),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: product['thumbnail_img'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: product[
                                  'thumbnail_img'], // Use full URL from API
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey),
                            ),
                          )
                        : const Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                    title: Text(
                      product['title'] ?? 'No title',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Author: ${product['author'] ?? 'Unknown'}"),
                        Text(
                            "Language: ${product['language'] ?? 'Not specified'}"),
                        Text("Price: ₹${product['price'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Search Books",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) => searchCategories(value),
              decoration: InputDecoration(
                hintText: 'Search by title, author, or language',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFAFAFAF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                ),
                filled: true,
                fillColor: const Color(0xFFF6F6F6),
              ),
            ),
            const SizedBox(height: 16.0),
            buildFilterTabs(),
            const SizedBox(height: 16.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildSearchResults(),
          ],
        ),
      ),
    );
  }
}
