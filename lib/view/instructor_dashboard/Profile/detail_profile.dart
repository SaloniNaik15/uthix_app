import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({Key? key}) : super(key: key);

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {

  final List<Map<String, dynamic>> profileData = [
    {'icon': Icons.person, 'label': 'You', 'hint': ''},
    {'icon': Icons.phone, 'label': '+91 XXXXX XXXXX', 'hint': ''},
    {'icon': Icons.email, 'label': 'mahimavardhan16@gmail.com', 'hint': ''},
    {'icon': Icons.lock, 'label': '********', 'hint': ''},  // Password field
    {'icon': Icons.female, 'label': 'Female', 'hint': ''},
    {'icon': Icons.location_on, 'label': 'Ip Extention, New Delhi', 'hint': ''},
    {'icon': Icons.school, 'label': 'Banaras Hindu University', 'hint': ''},
    {'icon': Icons.add, 'label': '+ Add Field', 'hint': ''},
    {'icon': Icons.school, 'label': 'B.Sc in Physics', 'hint': ''},
    {'icon': Icons.add, 'label': '+ Add Field', 'hint': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// Background image
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/Seller_dashboard_images/ManageStoreBackground.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            /// Top color strip + profile image
            Stack(
              children: [
                ColoredBox(
                  color: const Color(0xFF2B5C74),
                  child: SizedBox(
                    height: 40.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 80.w,
                        height: 80.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 40.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: Image.asset("assets/icons/profile.png"),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -1.h,
                        right: -1.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18.r,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.r,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// User name (e.g., "Mahima (You)")
            SizedBox(height: 10.h),
            Text(
              "(You)",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Profile fields
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: ListView.builder(
                  itemCount: profileData.length,
                  itemBuilder: (context, index) {
                    final item = profileData[index];
                    return ProfileField(
                      icon: item['icon'],
                      label: item['label'],
                      hint: item['hint'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      /// Submit Profile button at the bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B5C74),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            minimumSize: Size(double.infinity, 45.h),
          ),
          onPressed: () {
            // Handle submission logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile submitted!")),
            );
          },
          child: Text(
            "Submit Profile",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual profile row
class ProfileField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;

  const ProfileField({
    Key? key,
    required this.icon,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  late TextEditingController controller;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.label);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.label == "********";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: const Color(0xFFD2D2D2)),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.black54, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: isPasswordField ? obscurePassword : false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  isDense: true,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
            if (isPasswordField)
              IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                  size: 20.sp,
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
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Optional: handle an "edit" action
                    },
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
