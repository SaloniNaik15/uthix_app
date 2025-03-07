import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class BookDetails extends StatefulWidget {
  final String subcategory;
  const BookDetails({super.key, required this.subcategory});

  @override
  State<BookDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<BookDetails> {
  // TextEditingController _calendarController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minQtyController = TextEditingController();

  List<File> categoryImages = [];
  File? thumbnailImage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedImages = prefs.getStringList(widget.subcategory);
    final String? savedThumbnail =
        prefs.getString('${widget.subcategory}_thumb');

    if (savedImages != null) {
      setState(() {
        categoryImages = savedImages.map((path) => File(path)).toList();
      });
      log("📸 Loaded image paths in bookdetails: $savedImages");
    }

    if (savedThumbnail != null) {
      File tempFile = File(savedThumbnail);
      if (await tempFile.exists()) {
        setState(() {
          thumbnailImage = tempFile;
        });
      }
      log("📌 Loaded thumbnail image path in bookdetails: $savedThumbnail");
    }
  }

  /// ✅ **Fixed Image Compression**
  Future<File?> _compressImage(File originalFile) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      XFile? result = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: 70, // ✅ Adjust compression quality
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print("Image Compression Error: $e");
      return null;
    }
  }

  Future<void> _submitForm() async {
    const String url = "https://admin.uthix.com/api/vendor/products";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedCategoryIdStr = prefs.getString("selectedCategoryId");
    String? savedAccessToken = prefs.getString("userToken");

    if (selectedCategoryIdStr == null || selectedCategoryIdStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a category first.")),
      );
      return;
    }

    int categoryId = int.tryParse(selectedCategoryIdStr.trim()) ?? 0;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $savedAccessToken';

      // ✅ **Add Form Data**
      request.fields['title'] = _bookNameController.text;
      request.fields['author'] = _authorController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['category_id'] = categoryId.toString();
      request.fields['user_id'] = savedAccessToken ?? '';
      request.fields['isbn'] = _isbnController.text;
      request.fields['language'] = _languageController.text;
      request.fields['pages'] = _pagesController.text;
      request.fields['price'] = _priceController.text;
      request.fields['stock'] = _stockController.text;
      request.fields['min_qty'] = _minQtyController.text;
      request.fields['is_featured'] = '1';
      request.fields['is_published'] = '1';

      // ✅ **Handle Thumbnail Image**
      String? localThumbnailPath;
      if (thumbnailImage != null && thumbnailImage!.path.isNotEmpty) {
        File? compressedThumbnail =
            await _compressAndSaveImage(thumbnailImage!);
        if (compressedThumbnail != null) {
          print("📤 Attaching Thumbnail: ${compressedThumbnail.path}");
          request.files.add(await http.MultipartFile.fromPath(
            'thumbnail_img',
            compressedThumbnail.path,
          ));
          localThumbnailPath = compressedThumbnail.path;
        } else {
          print("❌ Thumbnail compression failed!");
        }
      } else {
        print("❌ No Thumbnail Image Selected!");
      }

      // ✅ **Handle Multiple Images**
      List<String> localImagePaths = [];
      for (File file in categoryImages) {
        File? compressedFile = await _compressAndSaveImage(file);
        if (compressedFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            compressedFile.path,
          ));
          localImagePaths.add(compressedFile.path);
          print("📌 Image added: ${compressedFile.path}");
        }
      }

      // ✅ **Debug: Log All Files Before Uploading**
      for (var file in request.files) {
        print("📤 Uploading: ${file.field} -> ${file.filename}");
      }

      // ✅ **Send Request**
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("📡 Response Code: ${response.statusCode}");
      log("📡 Response Body: $responseBody");

      if (response.statusCode == 201 || response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        // Import for logging
        String bookTitle = jsonResponse['product']['title'] ?? 'unknown_title';
        String productId = jsonResponse['product']['id']?.toString() ?? '';

        String timestamp = DateTime.now()
            .millisecondsSinceEpoch
            .toString(); // 🔥 Store as String

// ✅ Store in SharedPreferences
        // ✅ Store everything as a String
        await prefs.setString('product_id_$bookTitle', productId.toString());
        await prefs.setString('book_title_$productId', bookTitle);
        await prefs.setString('timestamp_$productId',
            DateTime.now().millisecondsSinceEpoch.toString());

// ✅ Log stored values
        log("✅ Stored: Product ID for $bookTitle -> $productId");
        log("✅ Stored: Book Title for Product ID $productId -> $bookTitle");
        log("✅ Stored: Timestamp for Product ID $productId -> $timestamp");

        // ✅ **Fix: Ensure the full URL for Server Thumbnail**
        String? serverThumbnail = jsonResponse['product']['thumbnail_img'] ??
            jsonResponse['product']['thumbnail'] ??
            jsonResponse['product']['image'];

        if (serverThumbnail == null || serverThumbnail.isEmpty) {
          if (jsonResponse['product']['images'] != null &&
              (jsonResponse['product']['images'] as List).isNotEmpty) {
            serverThumbnail =
                jsonResponse['product']['images'][0]['image_path'];
            print("📌 Using first image as thumbnail: $serverThumbnail");
          } else {
            print("❌ Warning: API did not return a valid thumbnail!");
            serverThumbnail = "";
          }
        }

        // ✅ **Ensure Server Thumbnail Stores Full URL**
        if (serverThumbnail != null && serverThumbnail.isNotEmpty) {
          serverThumbnail = "https://admin.uthix.com/uploads/$serverThumbnail";
        }

        // ✅ **Extract Server Image Paths**
        List<String> serverImagePaths = [];
        if (jsonResponse['product']['images'] != null) {
          serverImagePaths = (jsonResponse['product']['images'] as List)
              .map<String>((img) =>
                  "https://admin.uthix.com/uploads/${img['image_path']}")
              .toList();
        }

        // ✅ **Store in SharedPreferences using Book Title**
        await prefs.setString(
            'server_thumbnail_$bookTitle', serverThumbnail ?? '');
        await prefs.setString(
            'local_thumbnail_$bookTitle', localThumbnailPath ?? '');
        await prefs.setStringList('server_images_$bookTitle', serverImagePaths);
        await prefs.setStringList('local_images_$bookTitle', localImagePaths);
        await prefs.setString('response_body_$bookTitle', responseBody);

        log("✅ Stored in SharedPreferences: Server Thumbnail for $bookTitle -> $serverThumbnail");
        log("✅ Stored in SharedPreferences: Local Thumbnail for $bookTitle -> $localThumbnailPath");
        log("✅ Stored in SharedPreferences: Server Images for $bookTitle -> $serverImagePaths");
        log("✅ Stored in SharedPreferences: Local Images for $bookTitle -> $localImagePaths");
        // log("✅ Stored in SharedPreferences: Response Body for $bookTitle -> $responseBody");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Book uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to upload book: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred while uploading.")),
      );
    }
  }

  Future<File?> _compressAndSaveImage(File originalFile) async {
    try {
      // ✅ Get temporary storage directory
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // ✅ Compress the image
      final XFile? compressedImage =
          await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: 85, // Adjust quality (80-90 is good)
      );

      if (compressedImage != null) {
        print("✅ Compressed image saved at: ${compressedImage.path}");
        return File(compressedImage.path);
      } else {
        print("❌ Compression failed.");
        return null;
      }
    } catch (e) {
      print("❌ Error compressing image: $e");
      return null;
    }
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Book Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    "These details will be viewed by the students at the time of purchase",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  _buildTextFormField(
                    context,
                    'Book Name',
                    Icons.bookmark_add_outlined,
                    _bookNameController,
                  ),
                  const SizedBox(height: 26),

                  // Phone No Field
                  _buildTextFormField(context, ' Language',
                      Icons.bookmark_add_outlined, _languageController),
                  const SizedBox(height: 26),

                  // Gender Field
                  _buildTextFormField(context, 'ISBN Number',
                      Icons.bookmark_add_outlined, _isbnController),
                  const SizedBox(height: 26),

                  // Calendar Field
                  _buildTextFormField(context, 'Pages',
                      Icons.bookmark_border_outlined, _pagesController),
                  const SizedBox(height: 26),

                  // Location Field
                  _buildTextFormField(context, 'Author', Icons.menu_book_sharp,
                      _authorController),
                  const SizedBox(height: 26),

                  // University Field
                  _buildTextFormField(context, 'Price',
                      Icons.currency_rupee_rounded, _priceController),

                  SizedBox(height: 26),
                  _buildTextFormField(
                      context, 'Stock', Icons.price_check, _stockController),
                  SizedBox(height: 26),
                  _buildTextFormField(context, 'Quantity', Icons.price_check,
                      _minQtyController),
                  const SizedBox(height: 26),
                  _buildTextFormFieldWithMultiline(
                      context, _descriptionController),

                  const SizedBox(
                    height: 26,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                      print("sucessful");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B5C74),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                          fontSize: 15,
                          color:
                              Colors.white), // Style the Text widget directly
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    BuildContext context,
    String label,
    IconData prefixIcon,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Color(0xFFD2D2D2)),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFFCFCFC),
              ),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter $label';
              //   }
              //   return null;
              // },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormFieldWithMultiline(
    BuildContext context,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFCFCFC),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFFD2D2D2)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 5, // Allows multiline input
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Book description...',
              hintStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFFCFCFC),
            ),
            onChanged: (value) {
              // Truncate if it exceeds 100 words
              List<String> words = value.trim().split(RegExp(r'\s+'));
              if (words.length > 100) {
                controller.text = words.sublist(0, 100).join(' ');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter book description';
              }
              List<String> words = value.trim().split(RegExp(r'\s+'));
              if (words.length > 100) {
                return 'Text cannot exceed 100 words';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              int wordCount = value.text.trim().isEmpty
                  ? 0
                  : value.text.trim().split(RegExp(r"\s+")).length;
              return Text(
                '$wordCount/100 words',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              );
            },
          ),
        ),
      ],
    );
  }
}
