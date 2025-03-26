import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({Key? key}) : super(key: key);

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
    },
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
        backgroundColor: const Color(0xFF2B5C74),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                      Container(
                        width: 80.w,
                        height: 80.w,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   // gradient: const LinearGradient(
                        //   //   colors: [Colors.white, Colors.blue],
                        //   //   begin: Alignment.topLeft,
                        //   //   end: Alignment.bottomRight,
                        //   // ),
                        // ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 45.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45.r),
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
            SizedBox(height: 10.h),
            Text(
              "You",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
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

  const ProfileField({
    Key? key,
    required this.icon,
    required this.label,
    required this.hint,
  }) : super(key: key);

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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFC),
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
                  labelText: null,
                  hintText: widget.hint,
                  border: InputBorder.none,
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
                      // Handle edit action for this field
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
