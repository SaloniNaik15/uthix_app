import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../login/start_login.dart';
import '../Student Account Details/Student_Add_Address.dart';

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
  Map<String, dynamic>? selectedAddress;
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
          addresses =
          List<Map<String, dynamic>>.from(response.data['address']);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Save only the address type and ID persistently.
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
              ? Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
          ))
              : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  width: 60.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Text(
                  "Change Delivery Address",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 12.h, horizontal: 16.w),
                decoration:
                const BoxDecoration(color: Color(0xFFF1F1F1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Saved addresses",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
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
                      child: Text(
                        "+ Add Address",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,

                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // List of addresses.
              Column(
                children: addresses.map((address) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
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
                            fontSize: 14.sp,
                            fontWeight: selectedAddress != null &&
                                selectedAddress!['id'] ==
                                    address['id']
                                ? FontWeight.bold
                                : FontWeight.normal,

                          ),
                        ),
                        subtitle: Text(
                          "${address['street']}, ${address['city']}, ${address['state']} - ${address['postal_code']}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        trailing: OutlinedButton(
                          onPressed: () async {
                            // Extract and save only the `address_type`
                            String displayAddress =
                                address['address_type'] ?? "Home";

                            await saveSelectedAddress(
                                displayAddress, address['id']);

                            widget.onChangeAddress(address);

                            setState(() {
                              selectedAddress = address;
                            });

                            print("Address Selected: $displayAddress");
                            print("Address ID: ${address['id']}");

                            Navigator.pop(context, address);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF2B5C74)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Text(
                            "Change",
                            style: TextStyle(
                              color: const Color(0xFF2B5C74),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 3.h,
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    );
  }
}
