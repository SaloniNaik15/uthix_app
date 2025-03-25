// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:uthix_app/view/homeRegistration/otpPage.dart';

// class Successphone extends StatefulWidget {
//   const Successphone({super.key});

//   @override
//   State<Successphone> createState() => _SuccessphoneState();
// }

// class _SuccessphoneState extends State<Successphone> {
//   bool isagree1 = false;
//   bool isagree2 = false;
//   bool isagree3 = false;
//   final TextEditingController _phonenoController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Check keyboard visibility
//     final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

//     return Scaffold(
//       resizeToAvoidBottomInset: true, // Prevent UI overflow
//       body: Stack(
//         children: [
//           /// **Background Image (Full Screen)**
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.30,
//               child: Image.asset(
//                 "assets/registration/splash.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// **Back Button**
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, size: 20),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   /// **Title**
//                   Text(
//                     "Type your Phone Number",
//                     style: GoogleFonts.urbanist(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   /// **Phone Input Field**
//                   Row(
//                     children: [
//                       /// **Country Code**
//                       Container(
//                         height: 50,
//                         width: 61,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(246, 246, 246, 1),
//                           border: Border.all(
//                               color: const Color.fromRGBO(210, 210, 210, 1)),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "+91",
//                             style: GoogleFonts.urbanist(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                               color: const Color.fromRGBO(96, 95, 95, 1),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),

//                       /// **Phone Number Input**
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: const Color.fromRGBO(246, 246, 246, 1),
//                             border: Border.all(
//                                 color: const Color.fromRGBO(210, 210, 210, 1)),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextField(
//                               controller: _phonenoController,
//                               keyboardType: TextInputType.phone,
//                               style: GoogleFonts.urbanist(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: const Color.fromRGBO(96, 95, 95, 1),
//                               ),
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Phone Number",
//                                 hintStyle: GoogleFonts.urbanist(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w400,
//                                   color: const Color.fromRGBO(96, 95, 95, 1),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 35),

//                   /// **Checkbox Agreements**
//                   _buildCheckbox("I agree", isagree1, () {
//                     setState(() {
//                       isagree1 = !isagree1;
//                     });
//                   }),
//                   const SizedBox(height: 20),
//                   _buildCheckbox("I agree", isagree2, () {
//                     setState(() {
//                       isagree2 = !isagree2;
//                     });
//                   }),
//                   const SizedBox(height: 20),
//                   _buildCheckbox("I agree", isagree3, () {
//                     setState(() {
//                       isagree3 = !isagree3;
//                     });
//                   }),

//                   /// **Pushes Button to Bottom**
//                   const Spacer(),

//                   /// **"Send OTP" Button (Moves up when keyboard opens)**
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: EdgeInsets.only(bottom: isKeyboardOpen ? 20 : 50),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (context) => const Otppage()),
//                         );
//                       },
//                       child: Container(
//                         height: 50,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(27, 97, 122, 1),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Send OTP",
//                             style: GoogleFonts.urbanist(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// **Reusable Checkbox Widget**
//   Widget _buildCheckbox(String text, bool value, VoidCallback onTap) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 17,
//             width: 17,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               border: Border.all(color: Colors.black),
//               color: value
//                   ? const Color.fromRGBO(27, 97, 122, 1)
//                   : Colors.transparent,
//             ),
//             child: value
//                 ? const Center(
//                     child: Icon(Icons.check, size: 15, color: Colors.white),
//                   )
//                 : null,
//           ),
//         ),
//         const SizedBox(width: 20),
//         Text(
//           text,
//           style: GoogleFonts.urbanist(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: const Color.fromRGBO(96, 95, 95, 1),
//           ),
//         ),
//       ],
//     );
//   }
// }
