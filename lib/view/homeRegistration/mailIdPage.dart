import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'new_login.dart';

class Mailidpage extends StatefulWidget {
  final String role;
  const Mailidpage({super.key, required this.role});

  @override
  State<Mailidpage> createState() => _MailidpageState();
}

class _MailidpageState extends State<Mailidpage> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String? _selectedRole;
  bool ispassword = true;
  bool isconfirm = true;
  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role;
  }

  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final dio = Dio();
    final url = "https://admin.uthix.com/api/register";
    final body = {
      "name": _userNameController.text,
      "email": _emailIdController.text,
      "password": _passwordController.text,
      "role": _selectedRole,
    };

    try {

      final response = await dio.post(url,
          data: jsonEncode(body),
          options: Options(headers: {
            "Content-Type": "application/json",
          }));

      log("Response Code: ${response.statusCode}");
      log("Response Body: ${response.data}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewLogin()),
        );
      } else {
        log("Error: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Failed: ${response.data}")),
        );
      }
    } catch (e) {
      log("Dio Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.40,
              child: Image.asset(
                "assets/registration/splash.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 250,
                          child: Text(
                            "Type your Email Id and Create a Password",
                            style: GoogleFonts.urbanist(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: _userNameController,
                          hintText: "Please Enter Your Name",
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailIdController,
                          hintText: "Please type your Email Id",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: "Enter your Password",
                          isObscure: ispassword,
                          toggleObscure: () =>
                              setState(() => ispassword = !ispassword),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm Password",
                          isObscure: isconfirm,
                          toggleObscure: () =>
                              setState(() => isconfirm = !isconfirm),
                        ),
                        const SizedBox(height: 20),
                        _buildReadOnlyField(label: "Selected Role", value: _selectedRole ?? ""),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(27, 97, 122, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Next",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isObscure = false,
    VoidCallback? toggleObscure,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          style:
              GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle:
                GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
            suffixIcon: toggleObscure != null
                ? IconButton(
                    icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey),
                    onPressed: toggleObscure,
                  )
                : null,
          ),
        ),
      ),
    );
  }
  Widget _buildReadOnlyField({required String label, required String value}) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
