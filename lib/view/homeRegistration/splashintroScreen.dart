import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  _IntroscreenState createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  //Delayed for 3 sec.
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Registration()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SplashScreen
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.40,
              child: Image.asset("assets/registration/splash.png",
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 90,
            left: (MediaQuery.of(context).size.width - 160) / 2,
            child: Image.asset(
              "assets/registration/robot.png",
              width: 160,
              height: 172,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              height: 263,
              child: Image.asset(
                "assets/registration/bluetexture.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 540,
            left: (MediaQuery.of(context).size.width - 342) / 2,
            child: ClipOval(
              child: Image.asset(
                "assets/registration/logo1.png",
                width: 342,
                height: 338,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 629,
            left: (MediaQuery.of(context).size.width - 168) / 2,
            child: ClipOval(
              child: Image.asset(
                "assets/registration/logoshop.png",
                width: 168,
                height: 112,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 143,
            top: 293,
            child: Image.asset(
              "assets/registration/book.png",
              width: 111,
              height: 115,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 477,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                " A Live Teaching and\nEducational E-commerce App",
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(96, 95, 95, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
