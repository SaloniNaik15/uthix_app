import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../modal/Snackbar.dart';

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

  File? _selectedImage;

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

      // Read and compress
      final bytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage != null) {
        // Resize and compress
        img.Image resized =
            img.copyResize(originalImage, width: 800); // Max width
        final compressedBytes =
            img.encodeJpg(resized, quality: 80); // adjust quality

        // Save to temp dir
        final tempDir = await getTemporaryDirectory();
        final compressedPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        File compressedFile =
            await File(compressedPath).writeAsBytes(compressedBytes);

        setState(() {
          _selectedImage = compressedFile;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("logo", compressedFile.path);

        log("Compressed Image Path: $compressedPath");
        log("Image Size: ${compressedFile.lengthSync() / 1024} KB");
      }
    }
  }

  Future<void> _createStore() async {
    final prefs = await SharedPreferences.getInstance();

    final storeData = {
      "store_name": _storeNameController.text,
      "store_address": _addressController.text,
      "counter": _counterController.text,
      "school": _schoolController.text,
    };
    final formData = FormData.fromMap(storeData);

    if (_selectedImage != null && await _selectedImage!.exists()) {
      formData.files.add(MapEntry(
        "logo",
        await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: p.basename(_selectedImage!.path),
          contentType: MediaType("image", "jpeg"),
        ),
      ));
    } else {
      formData.fields.add(MapEntry("logo", ""));
    }

    // Cache locally
    final jsonData = json.encode(storeData);
    await prefs.setString("storeData", jsonData);
    log("Stored Data: $jsonData");

    final token = prefs.getString("auth_token");
    if (token == null || token.isEmpty) {
      log("⚠️ Authentication token is missing.");
      SnackbarHelper.showMessage(
        context,
        message: "Authentication failed. Please log in again.",
      );
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.post(
        "https://admin.uthix.com/api/vendor-store",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Store created successfully: ${response.data}");
        SnackbarHelper.showMessage(
          context,
          message: "Store created successfully!",
        );
      } else {
        log("❌ Store creation failed: ${response.statusCode}, ${response.data}");
        SnackbarHelper.showMessage(
          context,
          message: "Failed to create store: ${response.data}",
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        log("❌ Dio error: ${e.response?.statusCode} - ${e.response?.data}");
        SnackbarHelper.showMessage(
          context,
          message: "Error: ${e.response?.data}",
        );
      } else {
        log("❌ Unexpected error: $e");
        SnackbarHelper.showMessage(
          context,
          message: "Network error. Please try again. Error: $e",
        );
      }
    }
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
        title: const Text(
          "Create Store",
          style: TextStyle(
            fontSize: 18,
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
            // Row(
            //   children: [
            //     Image.asset('assets/icons/Ellipse.png', height: 50),
            //     const SizedBox(width: 7),
            //     const Text(
            //       "Hi Revantaha",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: Color(0xFF605F5F),
            //       ),
            //     ),
            //   ],
            // ),
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
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                        "Store Name", "e.g., ABC books", _storeNameController),
                    _buildTextField(
                        "Address", "location", _addressController),
                    _buildTextField(
                        "School/University", "e.g., BHU", _schoolController),
                    _buildTextField(
                        "Counter No.", "e.g., 0010", _counterController),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: const Color(0xFFD2D2D2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              _selectedImage == null
                                  ? "Upload Store Logo"
                                  : "Logo Selected",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _createStore();
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

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
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
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
