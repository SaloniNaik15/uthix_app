import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/successPage.dart';

class Otppage extends StatefulWidget {
  const Otppage({super.key});

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset("assets/registration/splash.png",
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                SizedBox(
                  width: 250,
                  height: 60,
                  child: Text(
                    "Enter the OTP sent to +91 XXXXX XXXXX",
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(210, 210, 210, 1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: [
                            _digit1Controller,
                            _digit2Controller,
                            _digit3Controller,
                            _digit4Controller
                          ][index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Text(
                  "Didn’t receive OTP?",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _digit1Controller.clear();
                          _digit2Controller.clear();
                          _digit3Controller.clear();
                          _digit4Controller.clear();
                        });
                      },
                      child: Container(
                        height: 36,
                        width: 124,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(27, 97, 122, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Resend OTP",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 36,
                      width: 124,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(27, 97, 122, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Request Call",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contxet) => Successpage()));
                    },
                    child: Container(
                      height: 50,
                      width: 323,
                      margin: const EdgeInsets.only(bottom: 20),
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
          ),
        ],
      ),
    );
  }
}
