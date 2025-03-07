import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'AdressSelection.dart';
import 'PaymentProcessing.dart';

class Studentcart extends StatefulWidget {
  const Studentcart({
    super.key,
  });

  @override
  State<Studentcart> createState() => _StudentcartState();
}

class _StudentcartState extends State<Studentcart> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double shippingCost = 40;
  double discount = 0;
  String selectedAddress = "Home";
  int selectedAddressId = 0;

  final Dio dio = Dio();
  final String token = "98|q4pMTma28DC2Ux7aYc42zOKaTD9ZhwkGo7gIHfGo63a49e1e";

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // 🔹 Fetch Cart Items API Call

  Future<void> fetchCartItems() async {
    const String apiUrl = "https://admin.uthix.com/api/cart";

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(response.data['cart']);
          isLoading = false;
        });
      } else {
        print("Failed to load cart items");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("1API Error: $e");
      setState(() => isLoading = false);
    }
  }

  // 🔹 Calculate Total Price
  double get totalAmount {
    double total = cartItems.fold(0.0, (sum, item) {
      double price = ((item['product']['discount_price'] ??
              item['product']['price']) as num)
          .toDouble();
      int quantity = item['quantity'];

      return sum + (quantity * price);
    });
    return total + shippingCost - discount;
  }

  void updateQuantity(int cartId, int newQuantity) {
    if (newQuantity < 1) {
      removeItem(cartId); // Remove item if quantity < 1
    } else {
      setState(() {
        var itemIndex = cartItems.indexWhere((item) => item['id'] == cartId);
        if (itemIndex != -1) {
          cartItems[itemIndex]['quantity'] = newQuantity;
        }
      });
    }
  }

  // Remove Item from Cart API Call (Permanent Deletion)
  Future<void> removeItem(int cartId) async {
    const String deleteUrl = "https://admin.uthix.com/api/remove";

    try {
      final response = await dio.delete(
        deleteUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {"cart_id": cartId},
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere(
              (item) => item['id'] == cartId); // Remove from UI permanently
        });
      } else {
        print("Failed to remove item from cart");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }

  Future<void> placeOrder() async {
    const String orderApiUrl = "https://admin.uthix.com/api/orders";

    final orderData = {
      "address_id": 1,
      "items": [
        {"product_id": 1, "quantity": 1, "price": 150}
      ],
      "shipping_charge": 50,
      "payment_method": "cod"
    };

    try {
      final response = await dio.post(
        orderApiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
        ),
        data: orderData,
      );

      if (response.statusCode == 201 &&
          response.data['message'] == "Order placed successfully") {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                orderId: response.data['order_id'],
                orderNumber: response.data['order_number'],
                totalPrice: 200, // 150 + 50 shipping
                addressId: 1,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to place order: ${response.data['message'] ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Urbanist",
            )),
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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              //  Address Section
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    color: const Color(0xFFF6F6F6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Deliver to this address: $selectedAddress",
                      style:
                          const TextStyle(fontSize: 14, fontFamily: "Urbanist"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return AddressSelectionSheet(
                                dio: dio, token: token);
                          },
                        );
                        if (result != null) {
                          setState(() {
                            selectedAddress = result;
                          });
                        }
                      },
                      child: const Text(
                        "Change",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B5C74)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              //  Cart Items List (Fetched from API)
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : cartItems.isEmpty
                        ? const Center(child: Text("Your cart is empty."))
                        : ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              final product = item['product'];
                              final int cartId = item['id'];
                              int quantity = item['quantity'];
                              final String title = product['title'];

                              // ✅ Convert price safely to double
                              final double price =
                                  ((product['discount_price'] ??
                                          product['price']) as num)
                                      .toDouble();

                              final String imageUrl = product[
                                          'thumbnail_img'] !=
                                      null
                                  ? 'https://admin.uthix.com/storage/image/products/${product['thumbnail_img']}'
                                  : "";

                              return buildCartItem(
                                  cartId, title, imageUrl, price, quantity);
                            },
                          ),
              ),

              // Discount Code Section
              Row(
                children: [
                  // Text Field (Expands to take available space)
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Discount Code or Gift Card",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Apply Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() => discount = 100); // Example discount
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: const Color(0xFFD9D9D9)),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //  Price Details
              const Divider(),
              buildPriceRow("Subtotal",
                  "₹${(totalAmount - shippingCost + discount).toStringAsFixed(2)}"),
              buildPriceRow("Shipping", "₹${shippingCost.toStringAsFixed(2)}"),
              buildPriceRow("Discount", "- ₹${discount.toStringAsFixed(2)}"),
              const Divider(),
              buildPriceRow("Total", "₹${totalAmount.toStringAsFixed(2)}",
                  isBold: true),
              const Divider(),
              const SizedBox(height: 10),

              //  Proceed to Payment Button
              ElevatedButton(
                onPressed: () => placeOrder(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: const Color(0xFF2B5C74),
                  elevation: 5,
                  shadowColor: Colors.black54,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Proceed to Payment",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Urbanist",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  // 🔹 Build Cart Item
  Widget buildCartItem(
      int cartId, String title, String imageUrl, double price, int quantity) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.network(imageUrl, width: 70, height: 90, fit: BoxFit.cover),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("₹${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),

                    // 📌 Quantity Control Buttons (No API Calls)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            updateQuantity(cartId, quantity - 1);
                          },
                        ),
                        Text("$quantity",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            updateQuantity(cartId, quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => updateQuantity(
                  cartId, 0), // ✅ Clicking delete sets quantity to 0
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isBold ? 16 : 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontFamily: "Urbanist")),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16 : 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontFamily: "Urbanist")),
        ],
      ),
    );
  }

  void showAddressBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressSelectionSheet(dio: dio, token: token);
      },
    );
    if (result != null) {
      setState(() {
        selectedAddress = result;
      });
    }
  }
}
