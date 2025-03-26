// ignore_for_file: unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + offset, 1);
      _selectedDay = _focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
          title: Text(
            "Calendar",
            style: GoogleFonts.urbanist(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(22), // Ensure it's fully circular
                  child: Image.asset(
                    "assets/login/profile.jpeg",
                    fit: BoxFit.cover,
                    width: 44, // Match double the radius
                    height: 44, // Match double the radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Schedule a class and update Student’s Calendar",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 400,
              //width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromRGBO(232, 232, 232, 1), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  // Month Navigation Bar with Selected Date
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy ,d').format(_focusedDay),
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildTable()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;

    final prevMonthLastDay =
        DateTime(_focusedDay.year, _focusedDay.month, 0).day;
    final nextMonthStart = 1;

    List<TableRow> rows = [];

    // Weekday Headers
    rows.add(
      TableRow(
        children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            .map((day) => Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Text(
                    day,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ))
            .toList(),
      ),
    );

    List<Widget> rowChildren = [];

    // Previous month dates
    for (int i = startWeekday - 1; i > 0; i--) {
      rowChildren.add(_buildDateCell(prevMonthLastDay - i + 1, false));
    }

    // Current month dates
    for (int day = 1; day <= daysInMonth; day++) {
      rowChildren.add(_buildDateCell(day, true));

      if ((rowChildren.length) % 7 == 0) {
        rows.add(TableRow(children: rowChildren));
        rowChildren = [];
      }
    }

    // Next month dates to fill the row
    int remainingCells = 7 - rowChildren.length;
    for (int i = 0; i < remainingCells; i++) {
      rowChildren.add(_buildDateCell(nextMonthStart + i, false));
    }
    rows.add(TableRow(children: rowChildren));

    return Table(
      border: TableBorder(
        horizontalInside:
            BorderSide(color: const Color.fromRGBO(232, 232, 232, 1), width: 1),
        verticalInside:
            BorderSide(color: const Color.fromRGBO(232, 232, 232, 1), width: 1),
      ),
      children: rows,
    );
  }

  Widget _buildDateCell(int? day, bool isInMonth) {
    return GestureDetector(
      onTap: () {
        if (day != null && isInMonth) {
          setState(() {
            _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, day);
          });
        }
      },
      child: Container(
        height: 82,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isInMonth
              ? Color.fromRGBO(255, 255, 255, 1)
              : Color.fromRGBO(250, 250, 250, 1),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isInMonth ? Colors.black : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
