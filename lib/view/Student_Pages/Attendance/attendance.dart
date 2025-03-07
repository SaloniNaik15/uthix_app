import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  double percentage = 77; // Update this value dynamically as needed

  @override
  Widget build(BuildContext context) {
    double progressValue =
        percentage / 100; // Convert percentage to progress value (0 to 1)

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(43, 92, 116, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              offset: const Offset(0, 0),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 25),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "My Attendance",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Total 9 classes attended out of 12",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Mahima Mandal",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(43, 92, 116, 1),
                ),
              ),
              Text(
                "Class X B",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              Text(
                "Delhi Public School, New Delhi",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              Text(
                "+91 XXXXX XXXXX",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 203,
                      height: 203,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(255, 237, 235, 235),
                        ),
                      ),
                    ),
                    // Inner Circle with Dynamic Progress
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 7,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(43, 92, 116, 1),
                        ),
                      ),
                    ),
                    // Percentage Text (Dynamic)
                    Text(
                      "$percentage%",
                      style: GoogleFonts.urbanist(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Need $percentage% to pass",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildInfoCard("Last Grade", "70%"),
                    buildInfoCard("Assignments", "5/8"),
                    buildInfoCard("Attendance", "$percentage%"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for info cards
  Widget buildInfoCard(String title, String value) {
    return Container(
      height: 102,
      width: 102,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ],
      ),
    );
  }
}
