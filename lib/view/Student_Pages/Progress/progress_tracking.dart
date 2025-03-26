// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  Widget buildInfoContainer(String title, String value) {
    return Container(
      height: 102.h,
      width: 102.w,
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
            title,
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryContainer(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color.fromRGBO(96, 95, 95, 1),
        ),
      ),
    );
  }

  Widget buildLegend(String text) {
    return Row(
      children: [
        Container(
          height: 15.h,
          width: 15.w,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        ),
        SizedBox(width: 3.w),
        Text(
          text,
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(96, 95, 95, 1),
          ),
        ),
      ],
    );
  }

  Widget buildBarChart() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 100,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
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

                    return (value.toInt() < 0 || value.toInt() >= labels.length)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[value.toInt()],
                              style: GoogleFonts.urbanist(
                                  fontSize: 6.sp, fontWeight: FontWeight.w700),
                            ),
                          );
                  },
                  reservedSize: 50.h,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }

  Widget buildStatisticsContainer() {
    return Container(
      height: 310.h,
      width: 340.w,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildCategoryContainer("Upcoming Exams"),
              buildCategoryContainer("Track Scores"),
            ],
          ),
          SizedBox(height: 20.h),
          buildBarChart(),
          Divider(
            thickness: 1,
            color: Color.fromRGBO(217, 217, 217, 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLegend("XX-YEAR 1"),
                buildLegend("XX-YEAR 1"),
              ],
            ),
          ),
        ],
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.h), // Custom AppBar height
            child: AppBar(
              backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
              elevation: 0, // Removes shadow

              automaticallyImplyLeading: false, // Removes default back arrow
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                    top: 10.h,
                    left: 10.w,
                    right: 10.w), // Adjust for top alignment
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 25.sp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "My Progress",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w), // width matches IconButton width
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      "Mahima Mandal",
                      style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(43, 92, 116, 1),
                      ),
                    ),
                    Text(
                      "Class X B",
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    Text(
                      "Delhi Public School, New Delhi",
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    Text(
                      "+91 XXXXX XXXXX",
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildInfoContainer("Last Grade", "70%"),
                          buildInfoContainer("Assignment", "5/8"),
                          buildInfoContainer("Attendance", "77%"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Performance Chart",
                          style: GoogleFonts.urbanist(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    buildStatisticsContainer()
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 75.h,
          left: (MediaQuery.of(context).size.width - 80) / 2.w,
          child: Container(
            width: 80.w,
            height: 80.h,
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
    );
  }
}
