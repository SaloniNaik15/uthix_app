import 'package:flutter/material.dart';
import 'Order_Processing.dart';

class OrdersTrackingPage extends StatelessWidget {
  const OrdersTrackingPage({super.key});

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
        title: const Text(
          "Orders and Tracking",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Color(0xFF605F5F),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search in orders",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF605F5F),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF605F5F)),
                      onPressed: () {
                        // Handle filter button tap
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(color: Color(0xFF605F5F), thickness: 2),
              SizedBox(height: 20),
              OrderCard(
                orderStatus: "Order is in Processing",
                orderDate: "2nd Feb",
                bookName: "Book Name",
                description: "Description",
                price: "₹1500",
                imagePath: "assets/Seller_dashboard_images/book.jpg",
                onUpdateStatus: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderProcessing()),
                  );
                },
              ),
              SizedBox(height: 15),
              Divider(color: Color(0xFF605F5F), thickness: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderStatus;
  final String orderDate;
  final String bookName;
  final String description;
  final String price;
  final String imagePath;
  final VoidCallback onUpdateStatus;

  const OrderCard({
    Key? key,
    required this.orderStatus,
    required this.orderDate,
    required this.bookName,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/icons/orderIcon.png', height: 40),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderStatus,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B5C74),
                  ),
                ),
                Text(
                  orderDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 380,
          width: 400,
          child: Card(
            color: Color(0xFFFCFCFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                color: Color(0xFFF4F4F4),
                width: 1,
              ),
            ),
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            height: 100,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookName,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onUpdateStatus,
                        icon: Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Color(0xFFAFAFAF)), // Single border
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Return",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Urbanist",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Color(0xFFAFAFAF)), // Single border
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Exchange",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Urbanist",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          5,
                          (index) => Icon(Icons.star_border_outlined, size: 28),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Give feedback and Earn Credit",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "Urbanist",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
