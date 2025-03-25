import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:uthix_app/view/Student_Pages/LMS/query_provider.dart';
import 'package:uthix_app/view/homeRegistration/splashintroScreen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUti

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
      designSize: const Size(375, 780),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.urbanistTextTheme(),
          ),
          home: Introscreen(),
          // home: Roleselection(),
          //home: SellerDashboard(),
          //home: InstructorDashboard(),
          //home: ECommerce(),
        );
      },
    );
  }
}
