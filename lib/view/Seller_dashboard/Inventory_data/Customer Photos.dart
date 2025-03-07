import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerPhotos extends StatefulWidget {
  const CustomerPhotos({super.key});

  @override
  State<CustomerPhotos> createState() => _CustomerPhotosState();
}

class _CustomerPhotosState extends State<CustomerPhotos> {
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
    );
  }
}
