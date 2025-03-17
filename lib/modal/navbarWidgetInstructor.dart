import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nav_items.dart'; // Import the global nav items

class Navbar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const Navbar({
    required this.onItemTapped,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 275,
      height: 59,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          navItems.length,
          (index) => GestureDetector(
            onTap: () => onItemTapped(index),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    navItems[index]["icon"],
                    size: 20,
                    color: selectedIndex == index
                        ? Colors.blue
                        : const Color.fromRGBO(96, 95, 95, 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    navItems[index]["title"],
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: selectedIndex == index
                          ? Colors.blue
                          : const Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
