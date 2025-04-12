import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetails extends StatefulWidget {
  final String subcategory;
  const BookDetails({super.key, required this.subcategory});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
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
    final prefs = await SharedPreferences.getInstance();
    final savedImages = prefs.getStringList(widget.subcategory);
    final savedThumbnail = prefs.getString('${widget.subcategory}_thumb');

    if (savedImages != null) {
      setState(() {
        categoryImages = savedImages.map((path) => File(path)).toList();
      });
      log("📸 Loaded images: $savedImages");
    }

    if (savedThumbnail != null) {
      final file = File(savedThumbnail);
      if (await file.exists()) {
        setState(() {
          thumbnailImage = file;
        });
      }
      log("📌 Loaded thumbnail: $savedThumbnail");
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Image compress error: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    const url = 'https://admin.uthix.com/api/vendor/products';

    final prefs = await SharedPreferences.getInstance();
    final categoryIdStr = prefs.getString('selectedCategoryId');
    final token = prefs.getString('auth_token');

    if (categoryIdStr == null || categoryIdStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a category first.')),
      );
      return;
    }

    final categoryId = int.tryParse(categoryIdStr) ?? 0;

    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final formData = FormData.fromMap({
        'title': _bookNameController.text,
        'author': _authorController.text,
        'description': _descriptionController.text,
        'category_id': categoryId.toString(),
        'isbn': _isbnController.text,
        'language': _languageController.text,
        'pages': _pagesController.text,
        'price': _priceController.text,
        'stock': _stockController.text,
        'min_qty': _minQtyController.text,
        'is_featured': '1',
        'is_published': '1',
      });

      if (thumbnailImage != null) {
        final compressed = await _compressImage(thumbnailImage!);
        final fileName = compressed!.path.split('/').last;
        formData.files.add(MapEntry(
          'thumbnail_img',
          await MultipartFile.fromFile(compressed.path, filename: fileName),
        ));
        log('📤 Thumbnail added: $fileName');
      }

      for (var image in categoryImages) {
        final compressed = await _compressImage(image);
        final fileName = compressed!.path.split('/').last;
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(compressed.path, filename: fileName),
        ));
        log('📤 Image added: $fileName');
      }

      final response = await dio.post(url, data: formData);

      log('📡 Status: ${response.statusCode}');
      log('📡 Response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('✅ Product created: ${response.data['product']['id']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      log('❌ Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while uploading.')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Arrow
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              // Book Details Title
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Book Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'These details will be viewed by the students\nat the time of purchase',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // All TextFields
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
              _buildTextFormField(
                  context, 'Author', Icons.menu_book_sharp, _authorController),
              const SizedBox(height: 26),

              // University Field
              _buildTextFormField(context, 'Price',
                  Icons.currency_rupee_rounded, _priceController),

              SizedBox(height: 26),
              _buildTextFormField(
                  context, 'Stock', Icons.price_check, _stockController),
              SizedBox(height: 26),
              _buildTextFormField(
                  context, 'Quantity', Icons.price_check, _minQtyController),
              const SizedBox(height: 26),
              _buildTextFormFieldWithMultiline(context, _descriptionController),
              const SizedBox(height: 20),
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Upload Book',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
