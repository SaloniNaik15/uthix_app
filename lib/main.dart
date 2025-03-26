import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uthix_app/view/Student_Pages/Modern_Tools/modern_tools.dart';
import 'package:uthix_app/view/homeRegistration/new_registerlogin.dart';

import 'package:uthix_app/view/Student_Pages/Modern_Tools/modern_tools.dart';
import 'package:uthix_app/view/homeRegistration/new_registerlogin.dart';

// import 'package:uthix_app/view/Student_Pages/LMS/query_provider.dart';
import 'package:uthix_app/view/homeRegistration/splashintroScreen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:uthix_app/view/homeRegistration/welcome_screen.dart';
import 'package:uthix_app/view/instructor_dashboard/panding.dart'; // Import ScreenUti

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
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.urbanistTextTheme(),
          ),
          home: Introscreen(),
          //home: panding(),
          // home: Roleselection(),
          // home: SellerDashboard(),
          // home: InstructorDashboard(),
          // home: ECommerce(),
          //home: NewRegisterlogin(),
          //home: SellerDashboard(),
          //home: InstructorDashboard(),
          //home: ECommerce(),
        );
      },
    );
  }
}
