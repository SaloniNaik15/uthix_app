// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'Pending.dart';

// class OrderStatusScreen extends StatefulWidget {
//   final String statusMessage;
//   final Color iconCircleColor;
//   final IconData statusIcon;
//   final bool showButtons;

//   const OrderStatusScreen({
//     super.key,
//     required this.statusMessage,
//     required this.iconCircleColor,
//     required this.statusIcon,
//     this.showButtons = false,
//   });

//   @override
//   State<OrderStatusScreen> createState() => _OrderStatusScreenState();
// }

// class _OrderStatusScreenState extends State<OrderStatusScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Auto-navigate after 3 seconds if showButtons is false
//     if (!widget.showButtons) {
//       Future.delayed(const Duration(seconds: 1), () {
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const Pending(status: '',)),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: 30.h),
//           child: _buildContainer(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     height: 80,
//                     width: 80,
//                     decoration: BoxDecoration(
//                       color: widget.iconCircleColor,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       widget.statusIcon,
//                       color: Colors.white,
//                       size: 49,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     widget.statusMessage,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),

//                   // Only show buttons if specified
//                   if (widget.showButtons)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _button("OK", const Color(0xFF2B5C74), () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const OrderStatusScreen(
//                                 statusMessage: "Order Rejected",
//                                 iconCircleColor: Colors.red,
//                                 statusIcon: Icons.close,
//                                 showButtons: false,
//                               ),
//                             ),
//                           );
//                         }),
//                         _button("Cancel", Colors.red, () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Pending(status: '',)),
//                           );
//                         }),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _button(String label, Color color, VoidCallback onTap) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }

//   Widget _buildContainer({required Widget child}) {
//     return Container(
//       width: 320.w,
//       padding: EdgeInsets.all(12.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6.r,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
