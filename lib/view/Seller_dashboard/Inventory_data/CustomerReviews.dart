import 'package:flutter/material.dart';

class Customerreviews extends StatefulWidget {
  const Customerreviews({super.key, required List reviews});

  @override
  State<Customerreviews> createState() => _CustomerreviewsState();
}

class _CustomerreviewsState extends State<Customerreviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Customer Reviews",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Keep the SingleChildScrollView for scrollability if needed
        child: Padding(
          // Add some padding for better visual appearance
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Main layout is a Column
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align to the start (left)
            children: [
              Row(
                // Row for rating and stars
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    "4.1",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Add some space between number and stars

                  Icon(Icons.star, color: Colors.amber, size: 12),
                  Icon(Icons.star, color: Colors.amber, size: 12),
                  Icon(Icons.star, color: Colors.amber, size: 12),
                  Icon(Icons.star, color: Colors.amber, size: 12),
                  Icon(Icons.star, color: Colors.amber, size: 12),
                ],
              ),
              const SizedBox(
                  height: 30), // Space between rating and "Customer Photos"

              Text(
                "Photos",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                // ListView
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(
                height: 20,
              ),

              ReviewCard(
                name: "User Name",
                timeAgo: "2 months ago",
                reviewText:
                    "Book are in good condition and got them on time,happen  with the packaging",
                rating: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String timeAgo;
  final String reviewText;
  final int rating;

  ReviewCard({
    required this.name,
    required this.timeAgo,
    required this.reviewText,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,

                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF2B5C74),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    "$rating",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(reviewText),
        SizedBox(height: 10),
        Text(
          "Reply",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
