import 'package:flutter/material.dart';

import 'CustomerPhotosPage.dart';
import 'CustomerReviewPage.dart';

class Bookdetails extends StatefulWidget {
  const Bookdetails({super.key, required product});

  @override
  State<Bookdetails> createState() => _BookdetailsState();
}

class _BookdetailsState extends State<Bookdetails> {
  List<String> images = [
    'assets/Seller_dashboard_images/book.jpg',
    'assets/Seller_dashboard_images/book.jpg',
    'assets/Seller_dashboard_images/book.jpg',
    'assets/Seller_dashboard_images/book.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel or grid view
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.55, // Adjust space between images
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                images[index], // Display each image
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    images.removeAt(
                                        index); // Remove image on cross click
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text description for the item
                  const Text(
                    "Relativity: The Special and the General Theory",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Hard Cover",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "5",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the start
                            children: [
                              Text(
                                "2,000",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Spacing between elements
                      Container(
                        width: double.infinity, // Full width
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Padding for spacing
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // Center content
                          children: [
                            Text(
                              "by Albert",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            const SizedBox(
                                width: 4), // Space between text and divider
                            Text(
                              "|",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "January",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "|",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "14th edition",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "New Simplified Physics Book by albert Einstein is a popular book for students studying physics, particulary in indian education SYstem",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //Delivery Instruction
                      deliveryInstructions(),

                      //Delivery date data
                      DeliveryDateWidget(),

                      SizedBox(
                        height: 20,
                      ),
                      //For Review and Rating
                      reviewAndRating(),
                      SizedBox(
                        height: 20,
                      ),

                      //Customer Review pages
                      CustomerReview(),
                      SizedBox(height: 10),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border,
                                  size: 18, color: Color(0xFF305C78)),
                              label: Text('Wishlist',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.shopping_bag_outlined,
                                  size: 18, color: Colors.white),
                              label: Text(
                                'Add to Bag',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFF305C78), // Dark blue shade
                                padding: EdgeInsets.symmetric(
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
            padding: EdgeInsets.all(5),
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF2B5C74),
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
      Builder(
        builder: (BuildContext context) {
          return TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentCustomerPhotos()),
              );
            },
            child: Text(
              "Customer Photos",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
              ),
            ),
          );
        },
      ),
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
      SizedBox(height: 20),
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
                padding: EdgeInsets.all(5),
                width: 70,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF2B5C74),
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
          SizedBox(height: 10),
          Text(
            'Books are in good condition and got them on time, happy with the packaging',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentPageCustomerReview()),
                      );
                    },
                    child: Text(
                      'View all 12 reviews',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
              Icon(
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

Widget deliveryInstructions() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/order_outline.png",
          text: "Get it till Friday, 17th January",
        ),
        const SizedBox(height: 15),
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/COD_icon.png",
          text: "COD is not available",
        ),
        const SizedBox(height: 15),
        _buildDeliveryRow(
          imagePath: "assets/Seller_dashboard_images/return_icon.png",
          text: "Problem free 7 days return and exchange",
        ),
      ],
    ),
  );
}

Widget _buildDeliveryRow({required String imagePath, required String text}) {
  return Row(
    children: [
      Image.asset(imagePath, height: 30),
      const SizedBox(width: 10),
      Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Urbanist',
        ),
      ),
    ],
  );
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? backgroundColor;

  const StatItem({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          // const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          if (icon != null)
            Icon(
              icon,
              size: 15,
              color: Colors.black87,
            ),
        ],
      ),
    );
  }
}
