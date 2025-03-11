import 'package:flutter/material.dart';

class InstructorFaq extends StatefulWidget {
  const InstructorFaq({super.key});

  @override
  State<InstructorFaq> createState() => _InstructorFaqState();
}

class _InstructorFaqState extends State<InstructorFaq> {
  // List to store the expanded state for each list item
  final List<bool> _expandedStates = List.filled(8, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Stack(
          children: [
            AppBar(
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
            Positioned(
              top: 40,
              right: -10,
              child: Image.asset(
                'assets/icons/FrequentlyAsked Questions.png', // Replace with your image path
                width: 80, // Adjust the size as needed
                height: 80,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color(0xFFD9D9D9), width: 1)),
                child: Column(
                  children: List.generate(8, (index) {
                    return Column(
                      children: [
                        _buildListTile(
                          index: index,
                          title:
                              "What is the required time duration for an order to get delivered?",
                        ),
                        if (_expandedStates[index])
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "What is the required time duration for an order to get delivered?",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Urbanist"),
                            ),
                          ),
                        const Divider(height: 1),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required int index,
    required String title,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: "Urbanist",
        ),
      ),
      trailing: Icon(
        _expandedStates[index]
            ? Icons.keyboard_arrow_up_outlined
            : Icons.keyboard_arrow_down_outlined,
        size: 25,
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          _expandedStates[index] = !_expandedStates[
              index]; // Toggle the expansion state for the selected item
        });
      },
    );
  }
}
