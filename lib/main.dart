import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUti
import 'package:uthix_app/view/homeRegistration/splashintroScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 780), // Adjust based on your design
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.urbanistTextTheme(),
          ),
          home: Introscreen(),

          //home: StartLogin(),
          //home: SellerDashboard(),
          //home: InstructorDashboard(),
          //home: ECommerce(),
        );
      },
    );
  }
}
