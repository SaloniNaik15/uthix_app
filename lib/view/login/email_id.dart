import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/login/main_combine.dart';
import 'package:uthix_app/view/login/reset_password.dart';

class EmailId extends StatefulWidget {
  const EmailId({super.key});

  @override
  State<EmailId> createState() => _EmailIdState();
}

class _EmailIdState extends State<EmailId> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool ispassword = true;

  void _login() async {
    String email = _emailIdController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://admin.uthix.com/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);
      log("API Response: $data"); // Log the full response

      if (response.statusCode == 200 && data.containsKey('access_token')) {
        // Store access token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);

        // Retrieve & log the stored token to verify
        String? storedToken = prefs.getString('access_token');
        log("Stored Token in SharedPreferences: $storedToken");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainCombine()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset("assets/registration/splash.png",
                    fit: BoxFit.cover),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 50),
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
                              controller: _emailIdController,
                              hint: "Please type your Email Id"),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                              },
                              child: Text(
                                "Forgot password?",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  color: Color.fromRGBO(96, 95, 95, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 20
                        : 40, // Moves up when keyboard appears
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _login();
                    },
                    child: Container(
                      height: 50,
                      width: 323,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(27, 97, 122, 1),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hint}) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(96, 95, 95, 1),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _passwordController,
          obscureText: ispassword,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(96, 95, 95, 1),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your Password",
            hintStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(96, 95, 95, 1),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  ispassword = !ispassword;
                });
              },
              child: Icon(
                ispassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
