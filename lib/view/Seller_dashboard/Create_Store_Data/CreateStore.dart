import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:uthix_app/view/Seller_dashboard/Create_Store_Data/Personal_details.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({super.key});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _counterController = TextEditingController();

  File? _selectedImage; // Stores selected image file

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _schoolController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      File? compressedImage = await _compressImage(imageFile);

      if (compressedImage != null) {
        setState(() {
          _selectedImage = compressedImage;
        });

        // Save the image path in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("logo", compressedImage.path);

        log("Saved Image Path: ${compressedImage.path}");
      }
    }
  }

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        path.join(dir.path, 'compressed_${path.basename(file.path)}');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85, // Adjust quality (0-100)
      minWidth: 800, // Resize width (optional)
      minHeight: 800, // Resize height (optional)
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _saveStoreData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> storeData = {
      "store_name": _storeNameController.text,
      "store_address": _addressController.text,
      "counter": _counterController.text,
      "school": _schoolController.text,
      "logo": _selectedImage?.path ?? "", // Store image path
    };

    String jsonData = json.encode(storeData);
    await prefs.setString("storeData", jsonData);

    log("Stored Data: $jsonData");
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: Color(0xFF605F5F),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
            ),
            filled: true,
            fillColor: const Color(0xFFF6F6F6),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Urbanist',
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Store",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Color(0xFF605F5F),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset('assets/icons/Ellipse.png', height: 50),
                const SizedBox(width: 7),
                const Text(
                  "Hi Revantaha",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF605F5F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFFFCFCFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFD2D2D2), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Create a New Store and Start Adding Books",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                        "Store Name", "e.g., Class A", _storeNameController),
                    _buildTextField(
                        "Address", "e.g., Class B", _addressController),
                    _buildTextField(
                        "School/University", "e.g., BHU", _schoolController),
                    _buildTextField(
                        "Counter No.", "e.g., 0010", _counterController),

                    const SizedBox(height: 10),
                    // Image Picker for Logo
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Color(0xFFD2D2D2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              _selectedImage == null
                                  ? "Upload Store Logo"
                                  : "Logo Selected",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _saveStoreData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalDetails()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5C74),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Create",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
