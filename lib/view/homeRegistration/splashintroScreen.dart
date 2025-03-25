// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uthix_app/view/homeRegistration/registration.dart';

// import '../Seller_dashboard/dashboard.dart';
// import '../instructor_dashboard/Dashboard/instructor_dashboard.dart';
// import '../login/main_combine.dart'; // Instructor Dashboard

// class Introscreen extends StatefulWidget {
//   const Introscreen({super.key});

//   @override
//   _IntroscreenState createState() => _IntroscreenState();
// }

// class _IntroscreenState extends State<Introscreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginState();
//   }

//   Future<void> _checkLoginState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('auth_token');
//     String? role = prefs.getString('user_role'); // Retrieve user role

//     // Simulate splash screen delay
//     await Future.delayed(Duration(seconds: 3));

//     if (token != null && role != null) {
//       if (role == "seller") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => SellerDashboard()),
//         );
//       } else if (role == "instructor") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => InstructorDashboard()),
//         );
//       } else {
//         // Default: Navigate to Student Home
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainCombine()),
//         );
//       }
//     } else {
//       // If no token, go to registration/login screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Registration()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.40,
//               child: Image.asset("assets/registration/splash.png",
//                   fit: BoxFit.cover),
//             ),
//           ),
//           Positioned(
//             top: 90,
//             left: (MediaQuery.of(context).size.width - 160) / 2,
//             child: Image.asset(
//               "assets/registration/robot.png",
//               width: 160,
//               height: 172,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               width: double.infinity,
//               height: 250,
//               child: Image.asset(
//                 "assets/registration/bluetexture.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 540,
//             left: (MediaQuery.of(context).size.width - 342) / 2,
//             child: ClipOval(
//               child: Image.asset(
//                 "assets/registration/logo1.png",
//                 width: 330,
//                 height: 280,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 600,
//             left: (MediaQuery.of(context).size.width - 168) / 2,
//             child: Image.asset(
//               "assets/registration/logoshop.png",
//               width: 150,
//               height: 100,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             left: 143,
//             top: 293,
//             child: Image.asset(
//               "assets/registration/book.png",
//               width: 111,
//               height: 115,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: 477,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 " A Live Teaching and\nEducational E-commerce App",
//                 style: GoogleFonts.urbanist(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(96, 95, 95, 1),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
