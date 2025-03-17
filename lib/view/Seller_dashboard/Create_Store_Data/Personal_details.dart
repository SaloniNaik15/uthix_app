import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as p;

class PersonalDetails extends StatefulWidget {
  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  bool isSubmitting = false;
  String? email;
  String? password;
  String? accessToken; // ✅ Store Dynamic Token

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  // ✅ Fetch Auth Token & User Details
  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email") ?? "No Email Found";
      password = prefs.getString("password") ?? "No Password Found";
      accessToken = prefs.getString("auth_token"); // ✅ Get auth_token
    });
  }

  // ✅ Submit Data with Dynamic Token
  Future<void> _submitData() async {
    if (!mounted) return;
    setState(() => isSubmitting = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeDataJson = prefs.getString("storeData");
    if (storeDataJson == null) {
      log("Error: Store data missing.");
      setState(() => isSubmitting = false);
      return;
    }

    Map<String, dynamic> storeData = json.decode(storeDataJson);

    String formattedDob = _dobController.text.trim();
    if (formattedDob.isNotEmpty) {
      try {
        DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(formattedDob);
        formattedDob = DateFormat("yyyy-MM-dd").format(parsedDate);
      } catch (e) {
        log("Error parsing date: $e");
        formattedDob = "";
      }
    }

    Map<String, String> personalData = {
      "name": _nameController.text,
      "email": email ?? "",
      "password": password ?? "",
      "mobile": _phoneController.text,
      "gender": _genderController.text,
      "dob": formattedDob,
      "address": _addressController.text,
      "store_name": storeData["store_name"] ?? "Default Store",
      "store_address": storeData["store_address"] ?? "Default Address",
      "school": storeData["school"] ?? "Default Store",
      "counter": storeData["counter"] ?? "N/A"
    };

    log("=== FINAL DATA TO BE SENT ===");
    log(jsonEncode(personalData));

    try {
      if (accessToken == null || accessToken!.isEmpty) {
        log("⚠️ No access token available. Cannot send request.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("⚠️ Authentication failed. Please log in again.")),
        );
        return;
      }

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://admin.uthix.com/api/vendor-store"),
      );

      request.headers.addAll({
        "Authorization": "Bearer $accessToken", // ✅ Dynamic Token
        "Accept": "application/json",
      });

      request.fields.addAll(personalData);

      if (storeData["logo"] != null && storeData["logo"].isNotEmpty) {
        File logoFile = File(storeData["logo"]);
        if (logoFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "logo",
              logoFile.path,
              filename: p.basename(logoFile.path),
            ),
          );
        }
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Data Submitted Successfully: $responseData");
      } else {
        log("❌ Submission Failed: ${response.statusCode}, $responseData");
      }
    } catch (e) {
      log("❌ Error submitting data: $e");
    }
    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Personal Details",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Edit your Personal Details before uploading",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextFormField("Name", Icons.person, _nameController),
              _buildTextFormField("Phone No", Icons.phone, _phoneController),
              _buildTextFormField("Gender", Icons.male, _genderController),
              _buildTextFormFieldWithDatePicker(
                  "DOB", Icons.calendar_month, _dobController),
              _buildTextFormField(
                  "Location", Icons.location_on_outlined, _addressController),
              _buildTextFormField(
                  "University", Icons.school, _universityController),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5C74),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormFieldWithDatePicker(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null && mounted) {
            setState(() {
              controller.text = DateFormat("dd/MM/yyyy").format(pickedDate);
            });
          }
        },
      ),
    );
  }
}
