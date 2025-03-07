import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buybookspages.dart';
import 'StudentSearch.dart';

class BuyTextBooks extends StatefulWidget {
  const BuyTextBooks({super.key});

  @override
  State<BuyTextBooks> createState() => _BuyTextBooksState();
}

class _BuyTextBooksState extends State<BuyTextBooks> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final dio = Dio();
      final response =
          await dio.get('https://admin.uthix.com/api/all-categories');

      print(response.data); // Debugging

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData.containsKey('categories') &&
            jsonData['categories'] is List) {
          setState(() {
            categories = (jsonData['categories'] as List)
                .map((item) => {
                      'id': item['id'] is int ? item['id'] : 0,
                      'cat_title': item['cat_title']?.toString() ?? 'No Title',
                      'cat_image': item['cat_image'] != null
                          ? 'https://admin.uthix.com/storage/image/category/${item['cat_image']}'
                          : '',
                    })
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            categories = [];
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF2B5C74),
          title: const Text(
            "Buy Textbooks",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentSearch()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                      ? const Center(
                          child: Text("No categories available",
                              style: TextStyle(fontSize: 18)),
                        )
                      : Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 1.0,
                              childAspectRatio: 1.20,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];

                              return buildGridItem(
                                context,
                                category['id'] as int,
                                category['cat_image'] ?? '',
                                category['cat_title'] ?? 'No Title',
                              );
                            },
                          ),
                        ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(
      BuildContext context, int categoryId, String image, String name) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Buybookspages(
              categoryId: categoryId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                image,
                width: 150,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 130,
                  color: Colors.grey,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(205, 205, 205, 0.16),
                    Color.fromRGBO(0, 0, 0, 0.71)
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
