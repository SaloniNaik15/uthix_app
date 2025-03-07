import 'package:flutter/material.dart';

class Customerphotoreview extends StatefulWidget {
  const Customerphotoreview({super.key});

  @override
  State<Customerphotoreview> createState() => _CustomerphotoreviewState();
}

class _CustomerphotoreviewState extends State<Customerphotoreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B5C74),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 8),
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
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aditi Pandey',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '2 months ago',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Books are in good condition and got them on time, happy with the packaging',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Reply',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
