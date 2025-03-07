import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Student_Add_Address.dart';


class StudentAddress extends StatefulWidget {
  const StudentAddress({super.key});

  @override
  State<StudentAddress> createState() => _StudentAddressState();
}

class _StudentAddressState extends State<StudentAddress> {
  int? selectedAddressIndex;
  List<Map<String, dynamic>> addresses = [];
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    String token = "98|q4pMTma28DC2Ux7aYc42zOKaTD9ZhwkGo7gIHfGo63a49e1e";
    BaseOptions options = BaseOptions(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    Dio dio = Dio(options);
    try {
      final response = await dio.get("https://admin.uthix.com/api/address");

      if (response.statusCode == 200 && response.data.containsKey("address")) {
        setState(() {
          addresses = List<Map<String, dynamic>>.from(response.data["address"]);
        });
      } else {
        print("Failed to fetch addresses: ${response.data}");
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
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
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold),
            ),
          ),

          // "Add New Address" button
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAddressScreen()),
              );
              _fetchAddresses(); // Refresh addresses after adding a new one
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
            child: addresses.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0 ||
                        addresses[index - 1]["address_type"] !=
                            address["address_type"])
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          address["address_type"] ?? "Other Addresses",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Urbanist",
                              fontWeight: FontWeight.bold),
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
                          color: selectedAddressIndex == index
                              ? Colors.white
                              : Color(0xFFF6F6F6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address["name"] ?? "N/A",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(address["area"] ?? "N/A"),
                            Text(address["street"] ?? ""),
                            Text(address["city"] ?? ""),
                            Text(address["postal_code"] ?? ""),
                            Text("Mobile Number: ${address["phone"] ?? "N/A"}"),
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
                                padding:
                                EdgeInsets.symmetric(horizontal: 40),
                              ),
                              child: Text("Edit",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _deleteAddress(address["id"]);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey),
                                padding:
                                EdgeInsets.symmetric(horizontal: 40),
                              ),
                              child: Text("Remove",
                                  style: TextStyle(
                                      fontFamily: "Urbanist",
                                      color: Colors.black)),
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

  Future<void> _deleteAddress(int addressId) async {
    String token = "31|q953ermY3FDJcidtQjCGfAstlUb8x4izaA0BMjMz53a72876";

    try {
      final response = await _dio.delete(
        "https://admin.uthix.com/api/address/$addressId",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Address deleted successfully")),
        );
        _fetchAddresses(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete address")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
