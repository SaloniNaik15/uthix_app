import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uthix_app/view/Ecommerce/e_commerce.dart';
import 'package:uthix_app/view/Seller_dashboard/dashboard.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/BookDetails.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/LMS/query_provider.dart';
import 'package:uthix_app/view/homeRegistration/splashintroScreen.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/live_classes.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/new_announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/calender/calender.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/login/start_login.dart';
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
