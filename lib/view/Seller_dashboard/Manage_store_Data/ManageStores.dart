import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Orders_Data/Oders.dart';

class ManageStoreData extends StatefulWidget {
  const ManageStoreData({super.key});

  @override
  State<ManageStoreData> createState() => _ManageStoreDataState();
}

class _ManageStoreDataState extends State<ManageStoreData> {
  String? selectedMonth; // Stores selected month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C74),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            "Manage Stores",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Seller_dashboard_images/ManageStoreBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("My Stores",
                        style: TextStyle(fontSize: 20, fontFamily: 'Urbanist')),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageOrders(),
                        ),
                      ),
                      child:
                          Image.asset("assets/icons/orderIcon.png", height: 35),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildStoreItem(
                      "Store Name ",
                      "Description ",
                      "School ",
                    );
                  },
                ),
                const SizedBox(height: 25),
                // Analytics Row with Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Analytics",
                      style: TextStyle(fontSize: 20, fontFamily: 'Urbanist'),
                    ),
                    SizedBox(
                      width: 150,
                      child: Card(
                        color: Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: MonthDropdownWidget(
                            onChanged: (String value) {
                              setState(() {
                                selectedMonth = value;
                              });
                            },
                            selectedValue: selectedMonth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 100,
                      child: Card(
                        color: Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Keeps content centered
                            children: [
                              Text(
                                "Net Profit",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.currency_rupee_rounded,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "60,000", // Example count (replace with dynamic value)
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Urbanist',
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 100,
                      child: Card(
                        color: Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Keeps content centered
                            children: [
                              Text(
                                "Total Products",
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5), // Spacing between texts
                              Text(
                                "200", // Example count (replace with dynamic value)
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 100,
                      child: Card(
                        color: Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Visitors",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "3.1k",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 250,
                  width: 400,
                  child: Card(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "This graph shows revenue of 2 years",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Card(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15), // Adds padding inside the Card
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Spaces elements
                        children: [
                          // Start Text
                          Text(
                            "Quantity in Stock",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),

                          // End Texts
                          Text(
                            "181",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Card(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Low Stock Items",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "20",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Card(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15), // Adds padding inside the Card
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Spaces elements
                        children: [
                          // Start Text
                          Text(
                            "Profit Margins",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),

                          // End Texts
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.currency_rupee_rounded,
                                color: Colors.black,
                              ),
                              Text(
                                "2,000", // Example count (replace with dynamic value)
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Card(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15), // Adds padding inside the Card
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Spaces elements
                        children: [
                          // Start Text
                          Text(
                            "Best Selling Items",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),

                          // End Texts
                          Text(
                            "50",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Month Dropdown Widget
class MonthDropdownWidget extends StatelessWidget {
  final String? selectedValue;
  final Function(String) onChanged;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  MonthDropdownWidget({super.key, required this.onChanged, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: const Text('This month'),
      menuMaxHeight: 200,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: months.map<DropdownMenuItem<String>>((String month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text(month),
        );
      }).toList(),
    );
  }
}

Widget _buildStoreItem(String name, String description, String school) {
  return Card(
    color: Color(0xFFE9EDF1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(
        color: Color(0xFFD2D2D2),
        width: 1,
      ),
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Name with Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/Seller_dashboard_images/CompanyLogo.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Description
              Center(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              // School
              Center(
                child: Text(
                  school,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        // Three dots menu on the top right corner
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (String value) {
              print("Selected: $value");
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete', 'View Details'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ),
      ],
    ),
  );
}
