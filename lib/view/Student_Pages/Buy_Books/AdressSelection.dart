import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Student Account Details/Student_Add_Address.dart';
import '../Student Account Details/Student_Address.dart';

class AddressSelectionSheet extends StatefulWidget {
  final Dio dio;
  final String token;
  final VoidCallback onAddAddress;
  final Function(Map<String, dynamic>) onChangeAddress;

  const AddressSelectionSheet({
    required this.dio,
    required this.token,
    required this.onAddAddress,
    required this.onChangeAddress,
    Key? key,
  }) : super(key: key);

  @override
  _AddressSelectionSheetState createState() => _AddressSelectionSheetState();
}

class _AddressSelectionSheetState extends State<AddressSelectionSheet> {
  List<Map<String, dynamic>> addresses = [];
  Map<String, dynamic>? selectedAddress; // Store locally selected address
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

  // Save only the address type and id persistently.
  Future<void> saveSelectedAddress(String addressType, int addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAddress', addressType);
    await prefs.setInt('selectedAddressId', addressId);
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
              // Drag indicator
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
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Change Delivery Address",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                decoration:
                const BoxDecoration(color: Color(0xFFF1F1F1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Saved addresses",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Urbanist",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAddressScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "+ Add Address",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Urbanist",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // List of addresses.
              Column(
                children: addresses.map((address) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        leading: Radio<Map<String, dynamic>>(
                          value: address,
                          groupValue: selectedAddress,
                          onChanged: (value) {
                            setState(() {
                              selectedAddress = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                        title: Text(
                          "${address['name']} - ${address['address_type']}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selectedAddress != null &&
                                selectedAddress!['id'] ==
                                    address['id']
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: "Urbanist",
                          ),
                        ),
                        subtitle: Text(
                          "${address['street']}, ${address['city']}, ${address['state']} - ${address['postal_code']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Urbanist",
                          ),
                        ),
                        trailing: OutlinedButton(
                          onPressed: () async {
                            // Use only the address_type for display.
                            String displayAddress =
                                address['address_type'] ?? "Home";
                            await saveSelectedAddress(
                                displayAddress, address['id']);
                            widget.onChangeAddress(address);
                            setState(() {
                              selectedAddress = address;
                            });
                            print("✅ Address Selected: $displayAddress");
                            print("✅ Address ID: ${address['id']}");
                            // Close the bottom sheet and return the selected address.
                            Navigator.pop(context, address);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF2B5C74)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Change",
                            style: TextStyle(
                              color: Color(0xFF2B5C74),
                              fontFamily: "Urbanist",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 3,
                      ),
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
