import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> addressData = {
      "user_id": 1,
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

    String token = "98|q4pMTma28DC2Ux7aYc42zOKaTD9ZhwkGo7gIHfGo63a49e1e";

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
            SnackBar(
                content: Text(
                    "Failed to save address: ${response.data["message"]}")),
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
        print(
            "Unexpected error: ${response.statusCode}, Response: ${response.data}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add Address",
            style: TextStyle(
                fontSize: 22,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name*", controller: _nameController),
              SizedBox(height: 10),
              _buildTextField("Mobile Number*",
                  keyboardType: TextInputType.phone,
                  controller: _phoneController),
              SizedBox(height: 10),
              _buildTextField("Alternate Phone",
                  keyboardType: TextInputType.phone,
                  controller: _altPhoneController),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.my_location),
                title: Text("Use my current Location",
                    style: TextStyle(fontSize: 14)),
                onTap: () {},
              ),
              SizedBox(height: 10),
              _buildTextField("Pin Code*",
                  keyboardType: TextInputType.number,
                  controller: _postalCodeController),
              SizedBox(height: 10),
              _buildTextField(
                "Address (House No, Building, Street, Area)*",
                controller: _areaController,
                helperText:
                    "Please update flat/house no. and society/apartment details",
                helperStyle: TextStyle(
                  color: Color(0xFFF99608),
                ),
              ),
              SizedBox(height: 10),
              _buildTextField("Street*", controller: _streetController),
              SizedBox(height: 10),
              _buildTextField("Landmark*", controller: _landmarkController),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField("City / District*",
                          controller: _cityController)),
                  SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField("State*",
                          controller: _stateController)),
                ],
              ),
              SizedBox(height: 10),
              Text("Address Type"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Home",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Urbanist')),
                      value: "Home",
                      groupValue: _addressType,
                      onChanged: (value) {
                        setState(() => _addressType = value.toString());
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("Office",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Urbanist')),
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
                  onChanged: (value) {
                    setState(() => _isDefault = value!);
                  },
                ),
                title: Text("Make this my default address",
                    style: TextStyle(fontSize: 12, fontFamily: 'Urbanist')),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                      ),
                      child: Text("Cancel",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Urbanist')),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B5C74)),
                      child: Text("Save",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Urbanist')),
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
      TextStyle? helperStyle}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD2D2D2)),
        ),
        fillColor: Color(0xFFD2D2D2),
        filled: label == "City / District*" || label == "State*" ? true : false,
        helperText: helperText,
        helperStyle: helperStyle,
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Required" : null,
    );
  }
}
