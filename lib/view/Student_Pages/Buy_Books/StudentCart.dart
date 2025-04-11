// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Student Account Details/Student_Add_Address.dart';
import '../Student Account Details/Student_Address.dart';
import 'AdressSelection.dart';
import 'PaymentProcessing.dart';

class Studentcart extends StatefulWidget {
  const Studentcart({Key? key, required List cartItems}) : super(key: key);

  @override
  State<Studentcart> createState() => _StudentcartState();
}

class _StudentcartState extends State<Studentcart> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double shippingCost = 40;
  double discount = 0;
  // Default values if no address saved.
  String selectedAddress = "home";
  int selectedAddressId = 0;
  String? authToken; // Store token

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    loadAuthToken();
    loadSelectedAddress();
    fetchCartItems();
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text("Authentication failed. Please login again.", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }

    setState(() {
      authToken = token;
    });
    loadSelectedAddress();
    fetchCartItems();
  }

  // Load saved address data from persistent storage.
  Future<void> loadSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAddress = prefs.getString('selectedAddress') ?? "Home";
      selectedAddressId = prefs.getInt('selectedAddressId') ?? 0;
    });
  }

  // Save the selected address data persistently.
  Future<void> saveSelectedAddress(String addressText, int addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAddress', addressText);
    await prefs.setInt('selectedAddressId', addressId);
  }

  Future<void> fetchCartItems() async {
    const String apiUrl = "https://admin.uthix.com/api/view-cart";

    if (authToken == null) return;

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(response.data['cart']['items'] ?? []);
          isLoading = false;
        });
      } else {
        print("Failed to load cart items: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("API Error: $e");
      setState(() => isLoading = false);
    }
  }

  double get totalAmount {
    double total = cartItems.fold(0.0, (sum, item) {
      double price = ((item['product']['price'] ?? item['product']['discount_price']) as num).toDouble();
      int quantity = item['quantity'];
      return sum + (quantity * price);
    });
    return total + shippingCost - discount;
  }

  // Place Order API Call
  Future<void> placeOrder() async {
    const String orderApiUrl = "https://admin.uthix.com/api/orders";

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("⚠️ Cart is empty. Please add items to proceed.", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }

    if (selectedAddressId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("⚠️ Please select a valid delivery address.", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }

    List<Map<String, dynamic>> orderItems = cartItems.map((item) {
      double price = (item['product']['discount_price'] ?? item['product']['price']).toDouble();
      int quantity = item['quantity'];
      return {
        "product_id": item['product']['id'],
        "quantity": quantity,
        "price": price,
        "total_price": (price * quantity).toStringAsFixed(2),
      };
    }).toList();

    double subtotal = cartItems.fold(0.0, (sum, item) {
      double price = (item['product']['discount_price'] ?? item['product']['price']).toDouble();
      return sum + (item['quantity'] * price);
    });

    double totalPrice = subtotal + shippingCost - discount;

    final orderData = {
      "address_id": selectedAddressId,
      "items": orderItems,
      "total_amount": totalPrice.toStringAsFixed(2),
      "shipping_charge": shippingCost.toStringAsFixed(2),
      "payment_method": "cod"
    };

    try {
      final response = await dio.post(
        orderApiUrl,
        options: Options(
            headers: {
              "Authorization": "Bearer $authToken",
              "Content-Type": "application/json"
            }),
        data: orderData,
      );

      if (response.statusCode == 201 && response.data['message'] == "Order placed successfully") {
        // if (context.mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => PaymentScreen(
        //         orderId: response.data['order_id'],
        //         orderNumber: response.data['order_number'],
        //         totalPrice: totalPrice.toInt(),
        //         addressId: selectedAddressId,
        //       ),
        //     ),
        //   );
        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("❌ Failed to place order: ${response.data['message'] ?? 'Unknown error'}",
                  style: TextStyle(fontSize: 14.sp))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("❌ Error placing order: ${e.toString()}", style: TextStyle(fontSize: 14.sp))),
      );
    }
  }

  // Remove Item from Cart API Call
  void removeFromCart(int cartId) async {
    final String apiUrl = "https://admin.uthix.com/api/remove-from-cart/$cartId";

    try {
      final response = await dio.delete(
        apiUrl,
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          cartItems.removeWhere((item) => item["id"] == cartId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Item removed from cart!", style: TextStyle(fontSize: 14.sp))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to remove item: ${response.data['message']}", style: TextStyle(fontSize: 14.sp))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}", style: TextStyle(fontSize: 14.sp))),
      );
    }
  }

  // Opens the bottom sheet and waits for the user to select an address.
  Future<void> showAddressBottomSheet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Authentication failed. Please login again.", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressSelectionSheet(
          dio: dio,
          token: token,
          onAddAddress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAddressScreen()),
            );
          },
          onChangeAddress: (address) {
            // Store only the address_type
            String displayAddress = address['address_type'] ?? "Home";

            setState(() {
              selectedAddress = displayAddress;
              selectedAddressId = address["id"];
            });

            // Save selected address type persistently
            saveSelectedAddress(displayAddress, address["id"]);

            print("✅ Address Selected: $selectedAddress");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B5C74)),
      ))
          : cartItems.isEmpty
          ? Center(
        child: Text(
          "Cart is Empty",
          style: TextStyle(fontSize: 18.sp,),
        ),
      )
          : Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: <Widget>[
              // Address Section
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD9D9D9)),
                    color: Color(0xFFF6F6F6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deliver to this address:",
                            style: TextStyle(
                                fontSize: 14.sp,
                               ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            selectedAddress,
                            style: TextStyle(
                                fontSize: 14.sp,

                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: showAddressBottomSheet,
                      child: Text(
                        "Change",
                        style: TextStyle(
                            fontSize: 14.sp,

                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B5C74)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = item['product'];
                    final int cartId = item['id'];
                    int quantity = (item['quantity'] != null)
                        ? (item['quantity'] as num).toInt()
                        : 1;
                    final String title = product['title'];
                    final double price = (product['price']).toDouble();
                    final String imageUrl =
                    (product['first_image'] != null &&
                        product['first_image']
                        ['image_path'] !=
                            null)
                        ? 'https://admin.uthix.com/storage/image/products/${product['first_image']['image_path']}'
                        : "https://via.placeholder.com/150";

                    return buildCartItem(
                        cartId,
                        title,
                        product['description'] ??
                            "No description available",
                        imageUrl,
                        price,
                        quantity,
                        index);
                  },
                ),
              ),
              // Discount Code Section
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Discount Code or Gift Card",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 10.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => discount = 100); // Example discount
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(5.r)),
                        backgroundColor: Color(0xFFD9D9D9)),
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          color: Colors.black,

                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Price Details
              Divider(),
              buildPriceRow("Subtotal",
                  "₹${(totalAmount - shippingCost + discount).toStringAsFixed(2)}"),
              buildPriceRow("Shipping",
                  "₹${shippingCost.toStringAsFixed(2)}"),
              buildPriceRow("Discount",
                  "- ₹${discount.toStringAsFixed(2)}"),
              Divider(),
              buildPriceRow(
                  "Total", "₹${totalAmount.toStringAsFixed(2)}",
                  isBold: true),
              Divider(),
              SizedBox(height: 8.h),
              // Proceed to Payment Button
              ElevatedButton(
                onPressed: () => placeOrder(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r)),
                  backgroundColor: Color(0xFF2B5C74),
                  elevation: 5,
                  shadowColor: Colors.black54,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white, size: 18.sp),
                    SizedBox(width: 10.w),
                    Text("Proceed to Payment",
                        style: TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Build Cart Item widget with quantity controls.
  Widget buildCartItem(int cartId, String title, String description,
      String imageUrl, double price, int quantity, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Color(0xFFF6F6F6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100.w,
                height: 100.h,
                color: Colors.white,
                child: Icon(Icons.image_not_supported,
                    size: 50.sp, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Product Details + Quantity Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  description,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline,
                          color: Colors.black, size: 20.sp),
                      onPressed: () {
                        setState(() {
                          if (cartItems[index]['quantity'] > 1) {
                            cartItems[index]['quantity'] =
                                cartItems[index]['quantity'] - 1;
                          } else {
                            removeFromCart(cartId);
                          }
                        });
                      },
                    ),
                    Text(
                      "${cartItems[index]['quantity']}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline,
                          color: Colors.black, size: 20.sp),
                      onPressed: () {
                        setState(() {
                          cartItems[index]['quantity'] =
                              cartItems[index]['quantity'] + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black, size: 20.sp),
                onPressed: () {
                  removeFromCart(cartId);
                },
              ),
              Text(
                "₹${price.toInt()}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isBold ? 16.sp : 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  )),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16.sp : 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  )),
        ],
      ),
    );
  }
}
