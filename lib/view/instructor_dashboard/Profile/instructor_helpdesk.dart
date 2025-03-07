import 'package:flutter/material.dart';

class InstructorHelpdesk extends StatefulWidget {
  const InstructorHelpdesk({super.key});

  @override
  State<InstructorHelpdesk> createState() => _InstructorHelpdeskState();
}

class _InstructorHelpdeskState extends State<InstructorHelpdesk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Help Desk",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 50,
                      width: 250,
                      child: Text(
                          "Please contact us and we will be happy to help you")),
                  Card(
                    child: Image.asset(
                      'assets/icons/HelpDesk.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Raise a Query",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Subject",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Start typing...",
                  filled: true,
                  hintStyle:
                      const TextStyle(fontFamily: "Urbanist", fontSize: 16),
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFFD2D2D2), width: 1)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Urbanist",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Start Typing...',
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  hintStyle:
                      const TextStyle(fontFamily: "Urbanist", fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFFD2D2D2), width: 1)),
                ),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "We will answer your query asap.",
                    style: TextStyle(fontSize: 16, fontFamily: "Urbanist"),
                  )),
              SizedBox(
                height: 80,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF605F5F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              // Rounded corners
                            )),
                        onPressed: () {
                          print("Outlined Button Pressed!");
                        },
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "Urbanist",
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
