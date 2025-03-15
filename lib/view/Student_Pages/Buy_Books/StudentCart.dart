import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        const SnackBar(content: Text("Authentication failed. Please login again.")),
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
        options: Options(headers: {"Authorization": "Bearer $authToken"}), // ✅ Dynamic Token
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


  // 🔹 Place Order API Call
  Future<void> placeOrder() async {
    const String orderApiUrl = "https://admin.uthix.com/api/orders";

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Cart is empty. Please add items to proceed.")),
      );
      return;
    }

    if (selectedAddressId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select a valid delivery address.")),
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
        options: Options(headers: {"Authorization": "Bearer $authToken", "Content-Type": "application/json"}), // ✅ Dynamic Token
        data: orderData,
      );

      if (response.statusCode == 201 && response.data['message'] == "Order placed successfully") {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                orderId: response.data['order_id'],
                orderNumber: response.data['order_number'],
                totalPrice: totalPrice.toInt(),
                addressId: selectedAddressId,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to place order: ${response.data['message'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error placing order: ${e.toString()}")),
      );
    }
  }

  // ✅ Remove Item from Cart API Call
  void removeFromCart(int cartId) async {
    final String apiUrl = "https://admin.uthix.com/api/remove-from-cart/$cartId";

    try {
      final response = await dio.delete(
        apiUrl,
        options: Options(headers: {"Authorization": "Bearer $authToken"}), // ✅ Dynamic Token
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          cartItems.removeWhere((item) => item["id"] == cartId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item removed from cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to remove item: ${response.data['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  // Opens the bottom sheet and waits for the user to select an address.
  Future<void> showAddressBottomSheet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication failed. Please login again.")),
      );
      return;
    }
     await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Urbanist",
          ),
        ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    "Cart is Empty",
                    style: TextStyle(fontSize: 18, fontFamily: "Urbanist"),
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        // Address Section
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFD9D9D9)),
                              color: const Color(0xFFF6F6F6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Deliver to this address:",
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: "Urbanist"),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      selectedAddress, // Display address type
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: showAddressBottomSheet,
                                child: const Text(
                                  "Change",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B5C74),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
                              final double price =
                                  (product['price']).toDouble();
                              final String imageUrl = (product['first_image'] !=
                                          null &&
                                      product['first_image']['image_path'] !=
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
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Discount Code or Gift Card",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: () {
                                setState(
                                    () => discount = 100); // Example discount
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
                        // Price Details
                        const Divider(),
                        buildPriceRow("Subtotal",
                            "₹${(totalAmount - shippingCost + discount).toStringAsFixed(2)}"),
                        buildPriceRow(
                            "Shipping", "₹${shippingCost.toStringAsFixed(2)}"),
                        buildPriceRow(
                            "Discount", "- ₹${discount.toStringAsFixed(2)}"),
                        const Divider(),
                        buildPriceRow(
                            "Total", "₹${totalAmount.toStringAsFixed(2)}",
                            isBold: true),
                        const Divider(),
                        const SizedBox(height: 10),
                        // Proceed to Payment Button
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

  // Build Cart Item widget with quantity controls.
  Widget buildCartItem(int cartId, String title, String description,
      String imageUrl, double price, int quantity, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF6F6F6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: Colors.white,
                child: const Icon(Icons.image_not_supported,
                    size: 50, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Details + Quantity Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.black),
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
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.black),
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
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  removeFromCart(cartId);
                },
              ),
              Text(
                "₹${price.toInt()}",
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Urbanist",
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
}
