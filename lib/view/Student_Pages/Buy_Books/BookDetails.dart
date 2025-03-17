import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/view/Seller_dashboard/Inventory_data/ViewDetails.dart';

import 'CustomerPhotosPage.dart';
import 'CustomerReviewPage.dart';

class Bookdetails extends StatefulWidget {
  final int productId;
  const Bookdetails({super.key, required this.productId});

  @override
  State<Bookdetails> createState() => _BookdetailsState();
}

class _BookdetailsState extends State<Bookdetails> {
  late Future<Map<String, dynamic>> productFuture;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
  }

  // Use Dio to build the API URL dynamically and fetch the product data.
  Future<Map<String, dynamic>> fetchProduct() async {
    try {
      final response = await _dio.get(
          "https://admin.uthix.com/api/products/view/${widget.productId}");
      if (response.statusCode == 200) {
        return response.data["product"];
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Failed to load product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color.fromARGB(255, 119, 78, 78),
              size: 20.sp,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 14.sp,),
                  ),
                );
              } else if (snapshot.hasData) {
                var product = snapshot.data!;
                // Extract dynamic list of images from the API data.
                List<dynamic> imagesData = product["images"] ?? [];
                List<String> images = imagesData.map((img) {
                  return "https://admin.uthix.com/storage/image/products/${img["image_path"]}";
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image carousel populated from API images.
                        SizedBox(
                          height: 200.h,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 20.w,
                              mainAxisSpacing: 10.h,
                              childAspectRatio: 0.55,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Center(
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        width: 0.5.sw,
                                        height: 200.h,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.broken_image, size: 50.sp);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15.h),
                        // Book title and details.
                        Text(
                          product["title"] ?? "No title",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product["isbn"] ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              "5",
                              style: TextStyle(
                                fontSize: 12.sp,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  product["price"].toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "by ${product["author"] ?? ""}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF605F5F),

                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "|",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xFF605F5F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    product["language"] ?? "",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF605F5F),

                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "|",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xFF605F5F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "${product["pages"]} pages",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF605F5F),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              product["description"] ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Delivery Instructions and Date widget.
                            deliveryInstructions(),
                            const DeliveryDateWidget(),
                            SizedBox(height: 10.h),
                            reviewAndRating(),
                            SizedBox(height: 10.h),
                            CustomerReview(),
                            SizedBox(height: 10.h),
                            // Bottom buttons: Each button takes half the phone screen width.
                            SafeArea(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        size: 18.sp,
                                        color: const Color(0xFF305C78),
                                      ),
                                      label: Text(
                                        'Wishlist',
                                        style: TextStyle(
                                          color: Colors.black,

                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.grey),
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 18.sp,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Add to Bag',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF305C78),
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 14.sp,),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class DeliveryDateWidget extends StatelessWidget {
  const DeliveryDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery Date",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "Pin Code",
              style: TextStyle(fontSize: 14.sp,),
            ),
            SizedBox(height: 5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "110092",
                      style: TextStyle(
                        fontSize: 14.sp,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add functionality to change pin code
                      },
                      child: Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget reviewAndRating() {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews & Ratings',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Container(
              //padding: EdgeInsets.all(2.w),
              width: 70.w,
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xFF2B5C74),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '4.2',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '49 Ratings & 12 reviews',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget CustomerReview() {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentCustomerPhotos()),
                );
              },
              child: Text(
                "Customer Photos",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,

                ),
              ),
            );
          },
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentCustomerPhotos()),
                  );
                },
                child: Container(
                  width: 80.w,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: Text(
                      'Item $index',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Reviews ',
              style: TextStyle(
                fontSize: 14.sp,

                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  //padding: EdgeInsets.all(5.w),
                  width: 70.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFF2B5C74),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '2 months ago',
                  style: TextStyle(
                    fontSize: 14.sp,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Books are in good condition and got them on time, happy with the packaging',
              style: TextStyle(
                fontSize: 14.sp,

                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudentPageCustomerReview()),
                        );
                      },
                      child: Text(
                        'View all 12 reviews',
                        style: TextStyle(
                          fontSize: 14.sp,

                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                Icon(Icons.arrow_forward_ios, size: 10.sp),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget deliveryInstructions() {
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Text(
        "Delivery Instructions: Please ensure someone is available to receive the package.",
        style: TextStyle(
          fontSize: 14.sp,

          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
