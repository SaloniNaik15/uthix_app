import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Student Account Details/Student_Add_Address.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  String _addressType = "Home";
  bool _isDefault = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  int? _userId;
  String? _pinError; // To store pincode error message

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Assume user_id is stored as an integer
    int? userId = prefs.getInt('user_id');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User data missing. Please log in again.")),
      );
      // Optionally, redirect to login:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartLogin()));
    } else {
      setState(() {
        _userId = userId;
      });
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed. Please log in again.")),
      );
      return;
    }
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found. Please log in again.")),
      );
      return;
    }

    final Map<String, dynamic> addressData = {
      "user_id": _userId, // Fetched dynamically
      "name": _nameController.text,
      "phone": _phoneController.text,
      "alt_phone": _altPhoneController.text,
      "address_type": _addressType.toLowerCase(),
      "landmark": _landmarkController.text,
      "area": _areaController.text,
      "street": _streetController.text,
      "postal_code": _postalCodeController.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "country": "India"
    };

    BaseOptions options = BaseOptions(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      followRedirects: false,
      validateStatus: (status) => status! < 500,
    );

    Dio dio = Dio(options);

    try {
      final response = await dio.post(
        "https://admin.uthix.com/api/address",
        data: addressData,
      );

      if (response.statusCode == 201) {
        if (response.data["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Address saved successfully")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save address: ${response.data["message"]}")),
          );
        }
      } else if (response.statusCode == 401) {
        print("Unauthorized: Invalid Token");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Session expired. Please log in again.")),
        );
      } else if (response.statusCode == 302) {
        print("Redirection detected to: ${response.headers['location']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected redirection. Try again later.")),
        );
      } else {
        print("Unexpected error: ${response.statusCode}, Response: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.data.toString()}")),
        );
      }
    } catch (e) {
      print("Dio error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
    }
  }

  // Fetch city and state from your existing API based on the entered pin code.
  Future<void> _fetchCityAndState(String pinCode) async {
    final String url = "https://admin.uthix.com/api/getCityState"; // Replace with your endpoint
    try {
      final response = await Dio().get(url, queryParameters: {"pin": pinCode});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data["status"] == true) {
          setState(() {
            _pinError = null; // Clear any previous error
            _cityController.text = data["city"] ?? "";
            _stateController.text = data["state"] ?? "";
          });
        } else {
          // The API indicates the pin is not valid
          setState(() {
            _pinError = "Incorrect pincode";
            _cityController.text = "";
            _stateController.text = "";
          });
        }
      } else {
        setState(() {
          _pinError = "Incorrect pincode";
          _cityController.text = "";
          _stateController.text = "";
        });
      }
    } catch (e) {
      print("Error fetching city and state: $e");
      setState(() {
        _pinError = "Network error";
        _cityController.text = "";
        _stateController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can wrap with ScreenUtilInit in your main app to use .w, .h, .sp, .r extensions.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add Address",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name*", controller: _nameController),
              SizedBox(height: 10),
              _buildTextField("Mobile Number*",
                  keyboardType: TextInputType.phone, controller: _phoneController),
              SizedBox(height: 10),
              _buildTextField("Alternate Phone",
                  keyboardType: TextInputType.phone, controller: _altPhoneController),
              SizedBox(height: 10),
              _buildTextField("Pin Code*",
                  keyboardType: TextInputType.number,
                  controller: _postalCodeController,
                  onChanged: (value) {
                    if (value.length == 6) {
                      _fetchCityAndState(value);
                    } else {
                      // Clear error if not 6 digits
                      setState(() {
                        _pinError = null;
                      });
                    }
                  },
                  errorText: _pinError),
              SizedBox(height: 10),
              _buildTextField("Address (House No, Building, Street, Area)*",
                  controller: _areaController,
                  helperText:
                  "Please update flat/house no. and society/apartment details",
                  helperStyle: TextStyle(
                    color: Color(0xFFF99608),
                    fontSize: 12,
                  )),
              SizedBox(height: 10),
              _buildTextField("Street*", controller: _streetController),
              SizedBox(height: 10),
              _buildTextField("Landmark*", controller: _landmarkController),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("City / District*",
                        controller: _cityController),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField("State*", controller: _stateController),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Address Type", style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      activeColor: Color(0xFF2B5C74),
                      title: Text("Home",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      value: "Home",
                      groupValue: _addressType,
                      onChanged: (value) {
                        setState(() => _addressType = value.toString());
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Color(0xFF2B5C74),
                      title: Text("Office",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      value: "Office",
                      groupValue: _addressType,
                      onChanged: (value) {
                        setState(() => _addressType = value.toString());
                      },
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Checkbox(
                  value: _isDefault,
                  activeColor: Color(0xFF2B5C74),
                  onChanged: (value) {
                    setState(() => _isDefault = value!);
                  },
                ),
                title: Text("Make this my default address",
                    style: TextStyle(fontSize: 12)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                      child: Text("Cancel",
                          style:
                          TextStyle(color: Colors.black, fontSize: 14)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B5C74)),
                      child: Text("Save",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller,
        String? helperText,
        TextStyle? helperStyle,
        Function(String)? onChanged,
        String? errorText}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD2D2D2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2B5C74), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        fillColor: Colors.white38,
        filled: label == "City / District*" || label == "State*" ? true : false,
        helperText: helperText,
        helperStyle: helperStyle,
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Required" : null,
    );
  }
}
