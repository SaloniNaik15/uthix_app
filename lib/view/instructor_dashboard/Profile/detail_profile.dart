import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({super.key});

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  final List<Map<String, dynamic>> profileData = [
    {'icon': Icons.person, 'label': 'Name', 'hint': 'Enter your name'},
    {'icon': Icons.phone, 'label': 'Phone', 'hint': 'Enter your phone number'},
    {'icon': Icons.email, 'label': 'Email', 'hint': 'Enter your email'},
    {
      'icon': Icons.lock,
      'label': 'Password',
      'hint': 'Enter your password'
    }, // Password field
    {'icon': Icons.female, 'label': 'Gender', 'hint': 'Select your gender'},
    {
      'icon': Icons.location_on,
      'label': 'Current Address',
      'hint': 'Enter your current address'
    },
    {
      'icon': Icons.school,
      'label': 'University',
      'hint': 'Enter your university'
    },
    {
      'icon': Icons.school,
      'label': 'University',
      'hint': 'Enter your university'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "Urbanist",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/Seller_dashboard_images/ManageStoreBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ColoredBox(
                  color: Color(0xFF2B5C74),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.asset("assets/icons/profile.png"),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Mahima (You)",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: profileData.length,
                  itemBuilder: (context, index) {
                    return ProfileField(
                      icon: profileData[index]['icon'],
                      label: profileData[index]['label'],
                      hint: profileData[index]['hint'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;

  const ProfileField(
      {super.key, required this.icon, required this.label, required this.hint});

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  late TextEditingController controller;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.label == "Password";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        decoration: BoxDecoration(
          color: Color(0xFFFCFCFC),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Color(0xFFD2D2D2)),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.black54),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: isPasswordField ? obscurePassword : false,
                decoration: InputDecoration(
                  labelText: null, // No label, only hint text
                  hintText: widget.hint, // Display hint text
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    fontSize: 16, fontFamily: "Urbanist", color: Colors.black),
              ),
            ),
            if (isPasswordField)
              IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              )
            else
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined,
                        size: 20, color: Colors.black),
                    onPressed: () {
                      // Handle edit action for this field
                    },
                  ),
                  Text(
                    "Edit",
                    style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(96, 95, 95, 1)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
