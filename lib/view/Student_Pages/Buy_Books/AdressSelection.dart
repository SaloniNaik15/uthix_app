import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressSelectionSheet extends StatefulWidget {
  final Dio dio;
  final String token;
  const AddressSelectionSheet({required this.dio, required this.token});

  @override
  _AddressSelectionSheetState createState() => _AddressSelectionSheetState();
}

class _AddressSelectionSheetState extends State<AddressSelectionSheet> {
  List<Map<String, dynamic>> addresses = [];
  String? selectedAddressType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    const String apiUrl = "https://admin.uthix.com/api/address";
    try {
      final response = await widget.dio.get(
        apiUrl,
        options: Options(headers: {"Authorization": "Bearer ${widget.token}"}),
      );
      if (response.statusCode == 200) {
        setState(() {
          addresses = List<Map<String, dynamic>>.from(response.data['address']);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Text("Change Delivery Address",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Urbanist")),
               ),
              const SizedBox(height: 10),
              // Saved Addresses Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(color: Color(0xFFF1F1F1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Saved addresses",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Urbanist")),
                    TextButton(
                      onPressed: () {
                        // Handle adding new address
                      },
                      child: const Text(
                        "+ Add Address",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Urbanist"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Column(
                children: addresses.map((address) {
                  bool isSelected = address['address_type'] == selectedAddressType;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        leading: Radio<String>(
                          value: address['address_type'],
                          groupValue: selectedAddressType,
                          onChanged: (value) {
                            setState(() {
                              selectedAddressType = value;
                            });
                            Navigator.pop(context, value);
                          },
                          activeColor: Colors.black,
                        ),
                        title: Text("${address['name']} - ${address['address_type']}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontFamily: "Urbanist")),
                        subtitle: Text(
                          "${address['street']}, ${address['city']}, ${address['state']} - ${address['postal_code']}",
                          style:
                          const TextStyle(color: Colors.black, fontFamily: "Urbanist"),
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {
                            // Handle change address action
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2B5C74)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Change",
                            style: TextStyle(
                                color: Color(0xFF2B5C74),
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      ),
                      Divider(color: Colors.grey[300], thickness: 3),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}