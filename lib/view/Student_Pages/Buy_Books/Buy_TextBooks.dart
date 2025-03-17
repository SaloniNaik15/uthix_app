import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/BuyBooksPages.dart';
import 'StudentSearch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyTextBooks extends StatefulWidget {
  // Make categoryId optional.
  final int? categoryId;
  const BuyTextBooks({Key? key, this.categoryId}) : super(key: key);

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
      final response = await dio.get('https://admin.uthix.com/api/all-categories');

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
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: const Color(0xFF2B5C74),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Buy Textbooks",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                // Uncomment the IconButton if you want a search button.
                // child: IconButton(
                //   icon: Icon(Icons.search, color: Colors.black, size: 20.sp),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => StudentSearch()),
                //     );
                //   },
                // ),
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
              //SizedBox(height: 10.h),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                  ? Center(
                child: Text("No categories available.",
                    style: TextStyle(fontSize: 18.sp)),
              )
                  : Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10.w),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0.w,
                    mainAxisSpacing: 0.5.h,
                    childAspectRatio: 1.3,
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
        margin: EdgeInsets.all(8.w),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                image,
                width: 150.w,
                height: 130.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150.w,
                  height: 130.h,
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported,
                      color: Colors.white, size: 100.sp),
                ),
              ),
            ),
            Container(
              width: 150.w,
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
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
                  padding: EdgeInsets.all(10.w),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
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
