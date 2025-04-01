import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ------------------- AppBar -------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upload Files",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(96, 95, 95, 1),
          ),
        ),
      ),
      // ------------------- Body -------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                // First row of options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _uploadOption(
                      imagePath: "assets/files_icons/document_pdf.png",
                      title: "Document",
                    ),
                    _uploadOption(
                      imagePath: "assets/files_icons/image.png",
                      title: "Gallery",
                    ),
                    _uploadOption(
                      imagePath: "assets/files_icons/document_pdf.png",
                      title: "Camera",
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                // Second row of options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _uploadOption(
                      imagePath: "assets/files_icons/document_pdf.png",
                      title: "Video",
                    ),
                    _uploadOption(
                      imagePath: "assets/files_icons/image.png",
                      title: "Link",
                    ),
                    _uploadOption(
                      imagePath: "assets/files_icons/document_pdf.png",
                      title: "Audio",
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                Text(
                  "The files uploaded by you will be accessible by all the participants of the class",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A helper widget for each upload option
  Widget _uploadOption({required String imagePath, required String title}) {
    return Column(
      children: [
        Container(
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(
              color: const Color.fromRGBO(217, 217, 217, 1),
              width: 1.w,
            ),
            color: const Color.fromRGBO(246, 246, 246, 1),
          ),
          child: Image.asset(imagePath),
        ),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
