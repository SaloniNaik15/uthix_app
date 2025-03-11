import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UploadedPhotos.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  List<File> selectedImages = []; // Store multiple images
  String? selectedCategory;
  String? selectedSubcategory;
  String? email;
  String? password;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadSelectedCategory();
  }

  Future<void> _loadSelectedCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategory =
          prefs.getString("selectedCategoryName") ?? "Uncategorized";
      selectedSubcategory = prefs.getString("selectedSubcategoryName");

      email = prefs.getString("userEmail") ?? "No Email Found";
      password = prefs.getString("password") ?? "No Password Found";
      accessToken = prefs.getString("userToken") ?? "No accessToken";
    });

    log(" Recived Selected Category: $selectedCategory");
    log("Recieved Selected Sub Category: $selectedSubcategory");
    log("Email: $email");
    log("Password: $password");
    log("Access Token: $accessToken");
  }

  // Pick an image from the camera
  // Pick an image from the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      selectedImages.add(imageFile); // Add image to list
      log("Captured Image Path: ${imageFile.path}");

      // Log all image paths in the list
      log("Current Images in List: ${selectedImages.map((file) => file.path).toList()}");

      navigateToUploadedPhotos(selectedImages);
    }
  }

// Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      selectedImages.add(imageFile); // Add image to list
      log("Selected Image Path: ${imageFile.path}");

      // Log all image paths in the list
      log("Current Images in List: ${selectedImages.map((file) => file.path).toList()}");

      navigateToUploadedPhotos(selectedImages);
    }
  }

  // Navigate to Uploaded Photos screen with the selected category
  void navigateToUploadedPhotos(List<File> imageFiles) {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select a category before uploading.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadedPhotos(
          imageFiles: imageFiles,
          category: selectedCategory!,
          subcategory: selectedSubcategory!,
        ),
      ),
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Upload Book",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Color(0xFF605F5F),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD2D2D2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Follow the steps for Your Book Inspection",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF605F5F),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildStep(
                        imagePath: 'assets/icons/gallery_image.png',
                        title: "Take Picture",
                        description:
                            "Capture images and videos of your book from different angles.",
                      ),
                      buildStep(
                        imagePath: 'assets/icons/bookk.png',
                        title: "Details of the Book",
                        description:
                            "Edit your personal details as well as the book details, ensuring accuracy.",
                      ),
                      buildStep(
                        imagePath: 'assets/icons/upload_icon.png',
                        title: "Upload",
                        description:
                            "After reviewing, hit the upload button to add it to your inventory.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),

          // Bottom Card with Camera & Gallery Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFD2D2D2),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera,
                            color: Colors.black, size: 35),
                        onPressed: pickImageFromCamera,
                      ),
                      const Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF605F5F),
                        ),
                      ),
                      const SizedBox(width: 50),
                      IconButton(
                          icon: const Icon(Icons.photo,
                              color: Colors.black, size: 35),
                          onPressed: pickImageFromGallery),
                      const Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF605F5F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display each step in the upload process
Widget buildStep(
    {required String imagePath,
    required String title,
    required String description}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imagePath, width: 70, height: 70),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ),
  );
}
