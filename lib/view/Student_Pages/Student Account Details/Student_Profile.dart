import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../../modal/Snackbar.dart';
import '../HomePages/HomePage.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String? accessLoginToken;
  String? networkImageUrl;
  int? selectedClassroomId;
  List<Map<String, dynamic>> _classOptions = [];
  bool isLoading = true;

  // Disable class dropdown after the first save
  bool _isClassDropdownEnabled = true;

  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String? _genderValue;
  final _classController = TextEditingController();
  final _streamController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    accessLoginToken = prefs.getString('auth_token');
    await _fetchClasses();
    await _fetchStudentProfile();
  }

  Future<void> _fetchClasses() async {
    try {
      final dio = Dio()
        ..options.headers['Authorization'] = 'Bearer $accessLoginToken';
      final resp = await dio.get('https://admin.uthix.com/api/all-classroom');
      if (resp.statusCode == 200 && resp.data['status'] == true) {
        _classOptions = List<Map<String, dynamic>>.from(
          resp.data['classrooms'].map((c) => {
                'id': c['id'],
                'name': c['class_name'],
              }),
        );
      }
    } catch (e) {
      log('Error fetching classes: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchStudentProfile() async {
    try {
      final dio = Dio();
      final resp = await dio.get(
        'https://admin.uthix.com/api/student-profile',
        options: Options(headers: {
          'Authorization': 'Bearer $accessLoginToken',
        }),
      );
      if (resp.statusCode == 200 && resp.data['status'] == true) {
        final data = resp.data['data'];
        final user = data['user'];
        final classroom = data['classroom'];
        selectedClassroomId = data['classroom_id'] as int?;
        final className = classroom != null ? classroom['class_name'] : '';
        final img = user['image'];
        setState(() {
          _nameController.text = user['name'] ?? '';
          _emailController.text = user['email'] ?? '';
          _phoneController.text = user['phone']?.toString() ?? '';
          _dobController.text = user['dob'] ?? '';
          _genderValue = user['gender'];
          _streamController.text = data['stream'] ?? '';
          _classController.text = className;
          networkImageUrl = (img != null && img.toString().isNotEmpty)
              ? 'https://admin.uthix.com/storage/images/student/$img'
              : null;
          // disable dropdown if a class is already set
          _isClassDropdownEnabled = selectedClassroomId == null;
        });
        // cache image url if any
        if (networkImageUrl != null) {
          await SharedPreferences.getInstance().then((p) =>
              p.setString('student_profile_image_url', networkImageUrl!));
        }
      }
    } catch (e) {
      log('Error fetching profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _profileImage = File(file.path));
  }

  Future<void> _submitProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    final gender = _genderValue;
    final userClass = _classController.text.trim();
    final stream = _streamController.text.trim();

    if ([name, email, phone, dob, userClass, stream].any((s) => s.isEmpty) ||
        gender == null) {
      SnackbarHelper.showMessage(
        context,
        message: 'Please fill all fields.',
      );
      return;
    }

    try {
      final dio = Dio();
      final form = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'gender': gender,
        'class': userClass,
        'stream': stream,
        'classroom_id': selectedClassroomId,
        if (_profileImage != null)
          'image': await MultipartFile.fromFile(_profileImage!.path,
              filename: 'profile.jpg'),
      });

      final resp = await dio.post(
        'https://admin.uthix.com/api/student-profile',
        data: form,
        options: Options(headers: {
          'Authorization': 'Bearer $accessLoginToken',
          'Accept': 'application/json',
        }),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        SnackbarHelper.showMessage(
          context,
          message: 'Profile updated successfully!',
        );
        // cache and navigate
        await SharedPreferences.getInstance()
            .then((p) => p.setString('cached_profile', jsonEncode(resp.data)));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePages()),
        );
      } else {
        throw Exception('Failed: ${resp.statusCode}');
      }
    } catch (e) {
      SnackbarHelper.showMessage(
        context,
        message: 'Error: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2B5C74),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePages()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (networkImageUrl != null
                          ? NetworkImage(networkImageUrl!)
                          : AssetImage('assets/icons/profile.png')
                              as ImageProvider),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF2B5C74),
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
                'Name', 'Enter your name', _nameController, Icons.person),
            _buildTextField(
                'Email', 'Enter your email', _emailController, Icons.email,
                keyboard: TextInputType.emailAddress),
            _buildTextField('Phone Number', 'Enter your phone',
                _phoneController, Icons.phone,
                keyboard: TextInputType.phone),
            _buildDateField('Date of Birth', 'dd-mm-yyyy', _dobController,
                Icons.calendar_month),
            _buildGenderDropdown(),
            _buildClassDropdown(),
            _buildTextField('Stream', 'e.g. Maths, Computer', _streamController,
                Icons.menu_book_outlined),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2B5C74),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                child: Text('Submit Profile', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            // SizedBox(child: ElevatedButton(
            //   onPressed: () {
            //     // A quick sanity‐check Flushbar
            //     Flushbar(
            //       message: 'Hello from Flushbar!',
            //       duration: const Duration(seconds: 2),
            //       margin: const EdgeInsets.all(16),
            //       borderRadius: BorderRadius.circular(8),
            //       flushbarPosition: FlushbarPosition.BOTTOM,
            //       animationDuration: const Duration(milliseconds: 400),
            //       forwardAnimationCurve: Curves.easeOutCubic,
            //       reverseAnimationCurve: Curves.easeInCubic,
            //     ).show(context);
            //   },
            //   child: const Text('Show Flushbar'),
            // ),)
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController ctrl, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Color(0xFFF6F6F6),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: Color(0xFFD2D2D2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: Color(0xFFD2D2D2)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildDateField(
      String label, String hint, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final dt = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Color(0xFF2B5C74),
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (dt != null) ctrl.text = '${dt.day}-${dt.month}-${dt.year}';
              },
            ),
            filled: true,
            fillColor: Color(0xFFF6F6F6),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: Color(0xFFD2D2D2)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Gender',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Color(0xFFD2D2D2)),
          ),
          child: DropdownButtonFormField<String>(
            value: _genderValue,
            decoration: InputDecoration(

                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12)),
            hint: Text('Select Gender'),
            dropdownColor: Colors.white,
            items: ['male', 'female', 'other']
                .map((g) =>
                    DropdownMenuItem(value: g, child: Text(g.capitalize())))
                .toList(),
            onChanged: (v) => setState(() => _genderValue = v),
          ),
        ),
      ]),
    );
  }

  Widget _buildClassDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Class',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Color(0xFFD2D2D2)),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
                  value: selectedClassroomId?.toString(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  hint: Text('Select Class'),
                  dropdownColor: Colors.white,
                  items: _classOptions
                      .map((c) => DropdownMenuItem(
                          value: c['id'].toString(), child: Text(c['name'])))
                      .toList(),
                  onChanged: _isClassDropdownEnabled
                      ? (val) {
                          final sel = _classOptions
                              .firstWhere((c) => c['id'].toString() == val);
                          setState(() {
                            selectedClassroomId = sel['id'];
                            _classController.text = sel['name'];
                          });
                        }
                      : null,
                  disabledHint: Text(_classController.text),
                ),
        ),
      ]),
    );
  }
}

extension on String {
  String capitalize() =>
      this.isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
