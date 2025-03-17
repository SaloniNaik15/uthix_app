import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int selectedFilterIndex = 0;
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
              final title =
                  product['title']?.toString().toLowerCase() ?? '';
              final author =
                  product['author']?.toString().toLowerCase() ?? '';
              final language =
                  product['language']?.toString().toLowerCase() ?? '';
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
      height: 40.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilterIndex = index;
                  searchController.text = filters[index];
                  searchCategories(filters[index]);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: selectedFilterIndex == index
                      ? Color(0xFF2B5C74)
                      : Colors.transparent,
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: selectedFilterIndex == index
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
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
                // Optionally, add navigation or other logic here
              });
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
                side: BorderSide(
                  color: const Color(0xFFF6F6F6),
                  width: 2,
                ),
              ),
              elevation: 5,
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.all(10.w),
                leading: product['thumbnail_img'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    'https://admin.uthix.com/storage/image/products/${product['first_image']['image_path']}',
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.image_not_supported,
                    size: 50.sp, color: Colors.grey),
                title: Text(
                  product['title'] ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Author: ${product['author'] ?? 'Unknown'}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Language: ${product['language'] ?? 'Not specified'}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Price: ₹${product['price'] ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
          icon:
          Icon(Icons.arrow_back_ios, color: const Color(0xFF605F5F), size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Recent Searches",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              focusNode: _focusNode,
              onChanged: (value) => searchCategories(value),
              decoration: InputDecoration(
                hintText: 'Search by title, author, or language',
                prefixIcon:
                Icon(Icons.search, color: const Color(0xFFAFAFAF), size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: isFocused
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFFD9D9D9),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: isFocused
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFFD9D9D9),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Color(0xFFAFAFAF), width: 2.0),
                ),
                filled: true,
                fillColor: const Color(0xFFF6F6F6),
              ),
            ),
            SizedBox(height: 16.h),
            buildFilterTabs(),
            SizedBox(height: 16.h),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                ? Center(
                child: Text("No results found",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp)))
                : buildSearchResults(),
          ],
        ),
      ),
    );
  }
}
