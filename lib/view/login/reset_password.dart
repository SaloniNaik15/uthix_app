import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool ispassword = true;
  bool isconfirm = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  "assets/registration/splash.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          "Reset Password",
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailIdController,
                          hintText: "Please type your Email Id",
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: "Enter your Password",
                          obscureText: ispassword,
                          isPassword: true,
                          onToggle: () {
                            setState(() {
                              ispassword = !ispassword;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm Password",
                          obscureText: isconfirm,
                          isPassword: true,
                          onToggle: () {
                            setState(() {
                              isconfirm = !isconfirm;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 40,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 50,
                      width: 323,
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onToggle,
  }) {
    return Container(
      height: 45,
      width: 333,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
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
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
