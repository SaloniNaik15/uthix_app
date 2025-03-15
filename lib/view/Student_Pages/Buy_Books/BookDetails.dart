import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
  }

  // Use the passed productId to build the API URL dynamically.
  Future<Map<String, dynamic>> fetchProduct() async {
    final response = await http.get(
      Uri.parse(
          "https://admin.uthix.com/api/products/view/${widget.productId}"),
    );
    if (response.statusCode == 200) {
      // Decode the response and extract the product object
      return json.decode(response.body)["product"];
    } else {
      throw Exception("Failed to load product");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 119, 78, 78),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var product = snapshot.data!;
            // Extract dynamic list of images from the API data
            List<dynamic> imagesData = product["images"] ?? [];
            // Update the mapping to the correct base URL:
            List<String> images = imagesData.map((img) {
              return "https://admin.uthix.com/storage/image/products/${img["image_path"]}";
            }).toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image carousel populated from API images
                        SizedBox(
                          height: 200,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.55,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 200,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.broken_image);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Book title and details from API
                        Text(
                          product["title"] ?? "No title",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product["isbn"] ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "5",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Icon(Icons.star, color: Colors.amber, size: 14),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  product["price"].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "by ${product["author"] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "|",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    product["language"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "|",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${product["pages"]} pages",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product["description"] ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Delivery Instructions
                            deliveryInstructions(),
                            const DeliveryDateWidget(),
                            const SizedBox(height: 20),
                            reviewAndRating(),
                            const SizedBox(height: 20),
                            CustomerReview(),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      size: 18,
                                      color: Color(0xFF305C78),
                                    ),
                                    label: const Text(
                                      'Wishlist',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.grey),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Add to Bag',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF305C78),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                ),
              ],
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

class DeliveryDateWidget extends StatelessWidget {
  const DeliveryDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Delivery Date",
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Pin Code",
            style: TextStyle(fontSize: 16, fontFamily: 'Urbanist'),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "110092",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add functionality to change pin code
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
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
    );
  }
}

Widget reviewAndRating() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Reviews & Ratings',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF2B5C74),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '4.2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '49 Ratings & 12 reviews',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget CustomerReview() {
  return Column(
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
          child: const Text(
            "Customer Photos",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
        );
      }),
      const SizedBox(height: 10),
      SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentCustomerPhotos()),
                );
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews ',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: 70,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF2B5C74),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '2 months ago',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Books are in good condition and got them on time, happy with the packaging',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Builder(builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentPageCustomerReview()),
                    );
                  },
                  child: const Text(
                    'View all 12 reviews',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
              const Icon(
                Icons.arrow_forward_ios,
                size: 10,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
