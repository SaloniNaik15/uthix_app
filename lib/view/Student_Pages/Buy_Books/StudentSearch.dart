import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class StudentSearch extends StatefulWidget {
  final int? categoryId;
  const StudentSearch({Key? key, this.categoryId}) : super(key: key);

  @override
  State<StudentSearch> createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  final List<String> filters = [
    'All',
    'Subject',
    'Books',
    'Stationary',
    'Lab Equipments',
  ];
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> searchCategories(String query) async {
    if (query.isEmpty) return;

    setState(() => isLoading = true);
    try {
      final dio = Dio();
      final String url = widget.categoryId != null
          ? 'https://admin.uthix.com/api/categories/${widget.categoryId}/products'
          : 'https://admin.uthix.com/api/categories/1/products';
      final response = await dio.get(
        url,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData.containsKey('products') && jsonData['products'] is List) {
          final List products = jsonData['products'];

          final queryLower = query.toLowerCase();
          setState(() {
            searchResults = products.where((product) {
              final title = product['title']?.toString().toLowerCase() ?? '';
              final author = product['author']?.toString().toLowerCase() ?? '';
              final language = product['language']?.toString().toLowerCase() ?? '';

              return title.contains(queryLower) ||
                  author.contains(queryLower) ||
                  language.contains(queryLower);
            }).toList();
          });
        } else {
          setState(() => searchResults = []);
        }
      }
    } catch (e) {
      setState(() => searchResults = []);
    } finally {
      setState(() => isLoading = false);
    }
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
                  searchController.text = filters[index];
                  searchCategories(filters[index]);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: Colors.transparent,
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color:  Colors.grey,
                    fontWeight: FontWeight.w400,
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
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];

          return GestureDetector(
            onTap: () {
              setState(() {
              });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Color(0xFFF6F6F6), // Change border color on selection
                  width: 2,
                ),
              ),
              elevation: 5,
              color: Colors.white, // Change background color
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: product['thumbnail_img'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://admin.uthix.com/storage/image/products/${product['first_image']['image_path']}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                title: Text(
                  product['title'] ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black, // Change text color
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Author: ${product['author'] ?? 'Unknown'}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Language: ${product['language'] ?? 'Not specified'}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Price: ₹${product['price'] ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:Colors.green,
                      ),
                    ),
                  ],
                ),
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
            fontWeight: FontWeight.normal,
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
              focusNode: _focusNode, // Attach focus node
              onChanged: (value) => searchCategories(value),
              decoration: InputDecoration(
                hintText: 'Search by title, author, or language',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFAFAFAF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: isFocused ? Color(0xFFAFAFAF) : const Color(0xFFD9D9D9), // Change border color on focus
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: isFocused ? Color(0xFFAFAFAF) : const Color(0xFFD9D9D9), // Default border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Color(0xFFAFAFAF), width: 2.0), // Red border when focused
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
                : searchResults.isEmpty
                ? const Center(child: Text("No results found", style: TextStyle(color: Colors.grey)))
                : buildSearchResults(),
          ],
        )
      ),
    );
  }
}