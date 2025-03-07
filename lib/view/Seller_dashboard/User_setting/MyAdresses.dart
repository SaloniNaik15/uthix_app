import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int? selectedAddressIndex;

  // Sample list of addresses
  final List<Map<String, String>> addresses = [
    {
      "name": "Mahima",
      "address": "101, Parivar Apartment, Narwana Road, IP Extension, New Delhi",
      "pincode": "110092",
      "mobile": "8601802774",
      "type": "Default Address"
    },
    {
      "name": "Mahima",
      "address": "101, Parivar Apartment, Narwana Road, IP Extension, New Delhi",
      "pincode": "110092",
      "mobile": "8601802774",
      "type": "Other Addresses"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,color: Color(0xFF605F5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "My Addresses",
              style: TextStyle(fontSize: 22,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold),
            ),
          ),

          // "Add New Address" button
          GestureDetector(
            onTap: () {
              // Handle add new address
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(
                "+Add New Address",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  color: Color(0xFF2B5C74),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ),

          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Titles
                    if (index == 0 || addresses[index - 1]["type"] != address["type"])
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          address["type"]!,
                          style: TextStyle(fontSize: 16, fontFamily: "Urbanist",fontWeight: FontWeight.bold),
                        ),
                      ),

                    // Address Card
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAddressIndex = index;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedAddressIndex == index ? Colors.white :  Color(0xFFF6F6F6),
                          border: Border.all(color: Colors.grey.shade300),

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address["name"]!,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(address["address"]!),
                            Text(address["pincode"]!),
                            Text("Mobile Number: ${address["mobile"]}"),
                          ],
                        ),
                      ),
                    ),

                    // Edit & Remove Buttons (Visible only if selected)
                    if (selectedAddressIndex == index)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle Edit Address
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey),
                                padding: EdgeInsets.symmetric(horizontal: 40),
                              ),
                              child: Text("Edit", style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  addresses.removeAt(index);
                                  selectedAddressIndex = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey),
                                padding: EdgeInsets.symmetric(horizontal: 40),
                              ),
                              child: Text("Remove", style: TextStyle(fontFamily: "Urbanist",color: Colors.black)),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16), // Spacing
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
