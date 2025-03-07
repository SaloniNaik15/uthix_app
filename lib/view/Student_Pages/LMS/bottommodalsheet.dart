import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorSelectionBottomSheet extends StatefulWidget {
  @override
  _ColorSelectionBottomSheetState createState() =>
      _ColorSelectionBottomSheetState();
}

class _ColorSelectionBottomSheetState extends State<ColorSelectionBottomSheet> {
  List<bool> isSelected = [false, false, false, false]; // ✅ Track selection

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      "Insert from your drive",
      "Add Your Work",
      "Camera",
      "Gallery"
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        for (int i = 0; i < labels.length; i++) ...[
          Divider(thickness: 1, color: Color.fromRGBO(217, 217, 217, 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(
                  labels[i],
                  style: GoogleFonts.urbanist(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected[i] = !isSelected[i];
                    });
                  },
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: isSelected[i] // ✅
                        ? Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(43, 92, 116, 1)),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 15),
      ],
    );
  }
}
