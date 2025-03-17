import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CustomerPhotosPage.dart';
import 'CustomerReviewPage.dart';
import 'BookDetails.dart';
import 'StudentCart.dart';
import 'StudentSearch.dart';
import 'Wishlist.dart';

class Bookdetails extends StatefulWidget {
  final int productId;
  const Bookdetails({super.key, required this.productId});

  @override
  State<Bookdetails> createState() => _BookdetailsState();
}

class _BookdetailsState extends State<Bookdetails> {
  late Future<Map<String, dynamic>> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
  }

  // Fetch product details using Dio.
  Future<Map<String, dynamic>> fetchProduct() async {
    try {
      final dio = Dio();
      final response = await dio.get(
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: const Color.fromARGB(255, 119, 78, 78), size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 14.sp)));
          } else if (snapshot.hasData) {
            var product = snapshot.data!;
            // Extract images from API data and map to full URL.
            List<dynamic> imagesData = product["images"] ?? [];
            List<String> images = imagesData.map((img) {
              return "https://admin.uthix.com/storage/image/products/${img["image_path"]}";
            }).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal list of product images.
                    SizedBox(
                      height: 200.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 20.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width / 2,
                                height: 200.h,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 40.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Book title and ISBN.
                    Text(
                      product["title"] ?? "No title",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      product["isbn"] ?? "",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10.h),
                    // Ratings Row.
                    Row(
                      children: [
                        Text(
                          "5", // Replace with dynamic rating if available.
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 5.w),
                        ...List.generate(
                            5,
                                (index) => Icon(Icons.star,
                                color: Colors.amber, size: 14.sp)),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    // Price and additional details.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["price"].toString(),
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.blue,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
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
                                    color: Colors.grey,
                                    fontFamily: 'Urbanist'),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                product["language"] ?? "",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                    fontFamily: 'Urbanist'),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "${product["pages"]} pages",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                    fontFamily: 'Urbanist'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          product["description"] ?? "",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.h),
                        // Delivery Instructions.
                        deliveryInstructions(),
                        SizedBox(height: 20.h),
                        const DeliveryDateWidget(),
                        SizedBox(height: 20.h),
                        reviewAndRating(),
                        SizedBox(height: 20.h),
                        CustomerReview(),
                        SizedBox(height: 10.h),
                        // Action Buttons: Wishlist & Add to Bag (each occupies half width).
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite_border,
                                      size: 18.sp,
                                      color: const Color(0xFF305C78)),
                                  label: Text(
                                    'Wishlist',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.grey),
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.shopping_bag_outlined,
                                      size: 18.sp, color: Colors.white),
                                  label: Text(
                                    'Add to Bag',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF305C78),
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: Text("No data available",
                    style: TextStyle(fontSize: 14.sp)));
          }
        },
      ),
    );
  }
}

Widget deliveryInstructions() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Delivery Instructions",
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        Text("Please note: We provide free delivery to your registered address.",
            style: TextStyle(fontSize: 14.sp, fontFamily: 'Urbanist')),
      ],
    ),
  );
}

class DeliveryDateWidget extends StatelessWidget {
  const DeliveryDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delivery Date",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Pin Code",
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Urbanist')),
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
                  Text("110092",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      // Functionality to change pin code goes here.
                    },
                    child: Text("Change",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Urbanist',
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviewAndRating() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews & Ratings',
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
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
                    Text('4.2',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text('49 Ratings & 12 reviews',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}

Widget CustomerReview() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(builder: (BuildContext context) {
          return TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentCustomerPhotos()),
              );
            },
            child: Text("Customer Photos",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist')),
          );
        }),
        SizedBox(height: 10.h),
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
                    child: Text('Item $index',
                        style: TextStyle(fontSize: 12.sp)),
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
            Text('Customer Reviews',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.w),
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
                        Text('3',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Text('2 months ago',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'Books are in good condition and got them on time, happy with the packaging',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Builder(builder: (BuildContext context) {
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
                          fontFamily: 'Urbanist',
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  );
                }),
                Icon(Icons.arrow_forward_ios, size: 10.sp),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

