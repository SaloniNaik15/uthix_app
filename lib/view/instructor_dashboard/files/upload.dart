import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
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
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Upload Files",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset(
                              "assets/files_icons/document_pdf.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Document",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset("assets/files_icons/image.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Gallery",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset(
                              "assets/files_icons/document_pdf.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Camera",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset(
                              "assets/files_icons/document_pdf.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Video",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset("assets/files_icons/image.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Link",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                            color: Color.fromRGBO(246, 246, 246, 1),
                          ),
                          child: Image.asset(
                              "assets/files_icons/document_pdf.png"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Audio",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "The files uploaded by you will be accessible by all the participants of the class ",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
