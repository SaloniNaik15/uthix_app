// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  Widget _buildCategoryContainer(String title) {
    return Container(
      height: 30,
      width: 129,
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1),
        border: Border.all(color: Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(77),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(96, 95, 95, 1),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(11, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 7.0, // Example values, adjust as needed
            width: 20, // **Increase width for wider bars**
            borderRadius: BorderRadius.zero, // **Make bars rectangular**
            color: Colors.blue, // Customize color
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(43, 92, 116, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
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
                      const SizedBox(width: 75),
                      Text(
                        "My Progress",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
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
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 102,
                      width: 102,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 246, 246, 1),
                        border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Last Grade",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          Text(
                            "70%",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 102,
                      width: 102,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 246, 246, 1),
                        border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Assignment",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          Text(
                            "5/8",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 102,
                      width: 102,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 246, 246, 1),
                        border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Attendance",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          Text(
                            "77%",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Performance Chart",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 310,
                width: 340,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 246, 246, 1),
                  border: Border.all(
                    color: Color.fromRGBO(217, 217, 217, 1),
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryContainer("Upcoming Exams"),
                        _buildCategoryContainer("Track Scores"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.center,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false), // Hide left (Y-axis)
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false), // Hide right (Y-axis)
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false), // Hide top titles
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles:
                                      true, // Show only bottom labels (months)
                                  getTitlesWidget: (value, meta) {
                                    List<String> labels = [
                                      "Jan XX",
                                      "Jan YY",
                                      "Feb XX",
                                      "Feb YY",
                                      "Mar XX",
                                      "Mar YY",
                                      "Apr XX",
                                      "Apr YY",
                                      "May XX",
                                      "May YY",
                                      "Jun XX"
                                    ];

                                    // Ensure the index is within bounds
                                    if (value.toInt() < 0 ||
                                        value.toInt() >= labels.length) {
                                      return Container(); // Return an empty widget if out of range
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        labels[value.toInt()],
                                        style: GoogleFonts.urbanist(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                                  },
                                  reservedSize:
                                      50, // Adjust space for bottom labels
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            barGroups:
                                _getBarGroups(), // Ensure _getBarGroups() returns wider bars
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "XX-YEAR 1",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "XX-YEAR 1",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 128 - 20,
            left: (MediaQuery.of(context).size.width - 80) / 2,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(51, 152, 246, 0.75),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
