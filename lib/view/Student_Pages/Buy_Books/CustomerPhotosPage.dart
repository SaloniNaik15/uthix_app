import 'package:flutter/material.dart';

import 'CustomerPhotoReview.dart';

class StudentCustomerPhotos extends StatefulWidget {
  const StudentCustomerPhotos({super.key});

  @override
  State<StudentCustomerPhotos> createState() => _StudentCustomerPhotosState();
}

class _StudentCustomerPhotosState extends State<StudentCustomerPhotos> {
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
          "Customer Photos",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Customerphotoreview()),
                );
              },
              child: Container(
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
    );
  }
}
