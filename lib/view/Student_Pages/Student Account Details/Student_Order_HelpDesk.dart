import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Student_HelpDesk.dart';

class StudentOrderHelpdesk extends StatefulWidget {
  const StudentOrderHelpdesk({super.key});

  @override
  State<StudentOrderHelpdesk> createState() => _StudentOrderHelpdeskState();
}

class _StudentOrderHelpdeskState extends State<StudentOrderHelpdesk> {
  List<Map<String, dynamic>> books = [
    {
      "image": "assets/Seller_dashboard_images/book.jpg",
      "title": "Book Name",
      "description": "Description",
      "price": "₹1500",
    },
    {
      "image": "assets/Seller_dashboard_images/book.jpg",
      "title": "Another Book",
      "description": "Another description",
      "price": "₹2000",
    },
    {
      "image": "assets/Seller_dashboard_images/book.jpg",
      "title": "Another Book",
      "description": "Another description",
      "price": "₹2000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Help Desk",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 50,
                      width: 250,
                      child: Text(
                          "Please contact us and we will be happy to help you")),
                  Card(
                    child: Image.asset(
                      'assets/icons/HelpDesk.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 20),
              const Text(
                "Do you need help with your recent order",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              BookList(books: books),

              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 20),
              const Text(
                "Browse these",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [
                  BrowseCard(icon: Icons.person, text: "Account"),
                  BrowseCard(icon: Icons.sync, text: "Returns and Exchange"),
                  BrowseCard(icon: Icons.local_offer, text: "Offers"),
                  BrowseCard(icon: Icons.credit_card, text: "Cancellation and Charge"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrowseCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const BrowseCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.yellow[100],
              child: Icon(icon, color: Colors.black),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16,fontFamily: "Urbanist",color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const BookList({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  OrderStatusRow(),
                  BookCard(book: books[index]),
                ],
              );
            },
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "View More",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class OrderStatusRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/orderIcon.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Order delivered successfully",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B5C74),
                  ),
                ),
                Text(
                  "2nd Feb",
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
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        color: const Color(0xFFFCFCFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Color(0xFFF4F4F4),
            width: 1,
          ),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentHelpdesk(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      book["image"],
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(book["description"],
                          style: TextStyle(color: Colors.grey[700])),
                      Text(
                        book["price"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

