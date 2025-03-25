import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';

class Forgot4 extends StatefulWidget {
  const Forgot4({super.key});

  @override
  State<Forgot4> createState() => _Forgot4State();
}

class _Forgot4State extends State<Forgot4> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Color _outerCircleColor = Colors.white;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Delay for 1 second before starting the tick animation and updating the circle color
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _outerCircleColor = const Color.fromARGB(255, 209, 207, 207);
      });
      _animationController.forward();
    });

    // When tick animation completes, reveal the rest of the content (fade in)
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Non-scrollable layout with centered content
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Full-screen background image with opacity
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  "assets/registration/splash.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Centered content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated tick circle that scales from small to full size
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 135.w,
                        height: 135.h,
                        decoration: BoxDecoration(
                          color: _outerCircleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(27, 97, 122, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 50.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Fade in the remaining content after the tick animation completes
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Text(
                            "Your Password has been Successfully Changed",
                            style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50.h),
                          // Back to Login Button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewLogin(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: const Color.fromRGBO(27, 97, 122, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Back to Login",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
