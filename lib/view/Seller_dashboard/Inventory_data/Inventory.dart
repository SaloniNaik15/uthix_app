import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart'; // Import Dio
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
  List<dynamic> products = [];
  String? accessToken;

  final List<String> filters = [
    'All',
    'Textbooks',
    'Notebooks',
    'Stationary',
    'Lab Equipment',
    'Book Marks'
  ];
  String selectedFilter = 'All';

  Dio dio = Dio(); // Instantiate Dio

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchProducts();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedaccessToken = prefs.getString("auth_token");

    log("Retrieved acesstoken: $savedaccessToken");

    setState(() {
      accessToken = savedaccessToken ?? "No accesstoken";
    });
  }

  Future<void> fetchProducts() async {
    const String url = 'https://admin.uthix.com/api/get/vendor/products';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;

        // 🔥 Log full JSON response here
        log("✅ Full API Response: ${jsonEncode(jsonResponse)}");

        List<dynamic> fetchedProducts = jsonResponse['products'];

        log("✅ Products fetched: ${fetchedProducts.length}");

        setState(() {
          products = fetchedProducts;
        });
      } else {
        log("❌ Failed to fetch products: ${response.statusCode}");
        log("❌ Response body: ${response.data}");
      }
    } catch (e) {
      log("❌ Error fetching products: $e");
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
            icon: const Icon(Icons.arrow_back_ios_outlined,
                color: Color(0xFF605F5F)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Catalogue",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Total Products: ${products.length}",
                style: const TextStyle(
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
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 15),
            // buildFilterChips(filters, selectedFilter, (filter) {
            //   setState(() {
            //     selectedFilter = filter;
            //   });
            //   print("Selected: $filter");
            // }),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        'No products found.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  );
                } else {
                  return BookList(products: products);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  final List<dynamic> products;

  const BookList({Key? key, required this.products}) : super(key: key);

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
            return buildProductCard(context, product);
          },
        ),
      ),
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    // Extract the first image URL from the product's images array and update the path
    String? imageUrl;
    if (product['images'] != null && product['images'].isNotEmpty) {
      imageUrl =
          'https://admin.uthix.com/storage/image/products/${product['images'][0]['image_path']}';
    }

    return GestureDetector(
      onTap: () {
        print('Tapped on: ${product['title']}');
      },
      child: Container(
        height: 550.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180.h,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 2.w),
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit
                            .cover, // Ensures the image fills the container
                      )
                    : Container(
                        color: Colors.grey[200],
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                product['title'] ?? 'No title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                '\₹${product['price'] ?? '0'}',
                style: TextStyle(
                  fontSize: 12.sp,

                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 3),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Viewdetails(
                      product: product,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.info, size: 16.sp, color: Colors.black),
              label: Text(
                "View Details",
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildFilterChips(List<String> filters, String selectedFilter,
    Function(String) onFilterSelected) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: filters.map((filter) {
        final isSelected = filter == selectedFilter;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(43, 96, 116, 1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color.fromRGBO(43, 96, 116, 1)
                      : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
