import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Upload_Data/Book_Details.dart';

class UploadedPhotos extends StatefulWidget {
  final String category;
  final List<File> imageFiles;
  final String subcategory;

  const UploadedPhotos({
    super.key,
    required this.category,
    required this.imageFiles,
    required this.subcategory,
  });

  @override
  State<UploadedPhotos> createState() => _UploadedPhotosState();
}

class _UploadedPhotosState extends State<UploadedPhotos> {
  Map<String, List<File>> categoryImages = {};
  File? thumbnailImage;

  @override
  void initState() {
    super.initState();

    log("📌 Received category in photos: ${widget.subcategory}");

    if (widget.subcategory.isNotEmpty) {
      categoryImages[widget.subcategory] = List.from(widget.imageFiles);
      _updateThumbnail(widget.subcategory);
    }

    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedImages = prefs.getStringList(widget.subcategory);
    final String? savedThumbnail =
        prefs.getString('${widget.subcategory}_thumb');

    log("🔍 Loading saved images for category: ${widget.subcategory}");

    if (savedImages != null) {
      setState(() {
        categoryImages[widget.subcategory] =
            savedImages.map((path) => File(path)).toList();
      });

      log("📸 Loaded image paths: $savedImages");
    } else {
      log("⚠️ No saved images found for category: ${widget.subcategory}");
    }

    if (savedThumbnail != null) {
      setState(() {
        thumbnailImage = File(savedThumbnail);
      });

      log("📌 Loaded thumbnail image path: $savedThumbnail");
    } else {
      log("⚠️ No thumbnail image found.");
    }
  }

  Future<void> _saveImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> imagePaths =
        categoryImages[widget.subcategory]?.map((file) => file.path).toList() ??
            [];

    await prefs.setStringList(widget.subcategory, imagePaths);
    if (thumbnailImage != null) {
      await prefs.setString(
          '${widget.subcategory}_thumb', thumbnailImage!.path);
    }

    log("💾 Saved images for category: ${widget.subcategory}");
    log("📸 Saved image paths: $imagePaths");

    if (thumbnailImage != null) {
      log("📌 Saved thumbnail image path: ${thumbnailImage!.path}");
    } else {
      log("⚠️ No thumbnail saved.");
    }
  }

  void _updateThumbnail(String category) {
    setState(() {
      if (categoryImages[category]?.isNotEmpty ?? false) {
        thumbnailImage = categoryImages[category]!.first;
        log("📌 Thumbnail Image Path: ${thumbnailImage!.path}");
      } else {
        thumbnailImage = null;
        log("⚠️ No thumbnail available.");
      }
    });
    _saveImages();
  }

  Future<void> pickNewImages(String category) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        if (!categoryImages.containsKey(category)) {
          categoryImages[category] = [];
        }
        categoryImages[category]!
            .addAll(selectedImages.map((e) => File(e.path)));
        _updateThumbnail(category);
      });
      _saveImages();
    } else {
      print("⚠️ No images selected.");
    }
  }

  void deleteImage(String category, int index) {
    setState(() {
      categoryImages[category]?.removeAt(index);
      _updateThumbnail(category);
    });
    _saveImages();
  }

  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetails(subcategory: widget.subcategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String subcategory = widget.subcategory;
    final List<File> images = categoryImages[subcategory] ?? [];

    print(
        "📌 Displaying images for category: $subcategory, Total Images: ${images.length}");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              color: Color(0xFF605F5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Uploaded Photos - $subcategory",
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Color(0xFF605F5F))),
      ),
      body: Column(
        children: [
          if (thumbnailImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Thumbnail Image:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(thumbnailImage!,
                        height: 150, width: 150, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () => pickNewImages(subcategory),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.camera_alt, color: Color(0xFF8E8C8C)),
                label:
                    const Text("Retake", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(images[index], fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => deleteImage(subcategory, index),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.close,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => pickNewImages(subcategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5C74),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Add Image",
                  style: TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: navigateToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5C74),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text("Next",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
