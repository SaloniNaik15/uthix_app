import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/push_notification_service.dart';
import 'package:uthix_app/view/homeRegistration/splashintroScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart'; // Import ScreenUti

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 FCM Token Refreshed: $newToken");

    // You can store it in shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', newToken);

  });

  await PushNotificationService().initialize();
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
          // home: child,
          // home: Roleselection(),
          // home: SellerDashboard(),
          // home: InstructorDashboard(),
          // home: ECommerce(),
          //   home: WelcomeScreen(),
          //home: NewRegisterlogin(),
          //home: SellerDashboard(),
          // home: AllSubmissionsScreen(),
          //home: InstructorDashboard(),
          // home: EmailId(),

        );
      },
      child: Introscreen(),
    );
  }
}
