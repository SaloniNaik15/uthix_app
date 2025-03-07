import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/homeRegistration/successPage.dart';

class Mailidpage extends StatefulWidget {
  const Mailidpage({super.key});

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

  final List<String> roles = ["seller", "instructor", "student"];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNameController.text = prefs.getString("userName") ?? "";
      _emailIdController.text = prefs.getString("userEmail") ?? "";
      _selectedRole = prefs.getString("userRole");
    });
  }

  Future<void> _saveUserCredentials(
      String email, String password, String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
    await prefs.setString("userToken", accessToken);
    print("Email & Password Saved: $email, $password,$accessToken");
  }

  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final url = Uri.parse("https://admin.uthix.com/api/register");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "name": _userNameController.text,
      "email": _emailIdController.text,
      "password": _passwordController.text,
      "role": _selectedRole,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      log("Response Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userToken", data["access_token"]);
        await prefs.setString("userName", data["user"]["name"]);
        await prefs.setString("userRole", data["user"]["role"]);
        await prefs.setString("userEmail", data["user"]["email"]);

        // Save email and password
        await _saveUserCredentials(_emailIdController.text,
            _passwordController.text, data["access_token"]);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Successpage()),
        );
      } else {
        log("Error: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Failed: ${response.body}")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
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
                    toggleObscure: () => setState(() => isconfirm = !isconfirm),
                  ),
                  const SizedBox(height: 20),
                  _buildRoleDropdown(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: _registerUser,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(27, 97, 122, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
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
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(96, 95, 95, 1),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
            suffixIcon: toggleObscure != null
                ? GestureDetector(
                    onTap: toggleObscure,
                    child: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          hint: const Text("Please Select Your Role"),
          isExpanded: true,
          items: roles.map((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue;
            });
          },
        ),
      ),
    );
  }
}
