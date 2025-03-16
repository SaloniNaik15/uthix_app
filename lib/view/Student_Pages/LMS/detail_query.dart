import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailQuery extends StatefulWidget {
  const DetailQuery({super.key});

  @override
  State<DetailQuery> createState() => _DetailQueryState();
}

class _DetailQueryState extends State<DetailQuery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
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
            child: ClipOval(
              child: Image.asset(
                "assets/login/profile.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SUBJECT: Mathematics",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(16, 95, 131, 1),
              ),
            ),
            Text(
              "CHAPTER: Algebra by Om Prakash",
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(132, 132, 132, 1),
              ),
            ),
            const SizedBox(height: 10),

            /// **Expanded allows `ListView.builder` to take available space**
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailQuery()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(246, 246, 246, 1),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: const Color.fromRGBO(217, 217, 217, 1),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    "assets/login/profile.jpeg",
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Surayaiya Jagannath",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.more_vert),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Submit", // Dynamic query display
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Add Attachment",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(142, 140, 140, 1),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: const Color.fromRGBO(213, 213, 213, 1),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            Text(
                              "Add Comment",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(142, 140, 140, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
