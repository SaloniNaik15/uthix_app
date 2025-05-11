import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStudent extends StatefulWidget {
  final int chapterId;
  const LiveStudent({super.key, required this.chapterId});

  @override
  State<LiveStudent> createState() => _LiveStudentState();
}

class _LiveStudentState extends State<LiveStudent> {
  late Future<Map<String, dynamic>> _liveDataFuture;

  @override
  void initState() {
    super.initState();
    _liveDataFuture = fetchLiveStreamData(widget.chapterId);
  }

  Future<Map<String, dynamic>> fetchLiveStreamData(int chapterId) async {
    try {
      Dio dio = Dio();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Auth token is missing. Please login again.");
      }

      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        'https://admin.uthix.com/api/class/join',
        data: {
          'chapter_id': chapterId.toString(), // ✅ Ensure string
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Status code: ${response.statusCode}");
      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        debugPrint("Live stream data: ${response.data}");
        return response.data;
      } else {
        throw Exception("Failed to load student live stream");
      }
    } catch (e) {
      print("Error fetching live stream data: $e");
      throw Exception("Error fetching live stream data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Class - Student ",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _liveDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final liveData = snapshot.data!;
          final String userID = liveData['user_id'].toString();
          final String userName = liveData['teacher_name'] ?? "Student";
          final String liveID = liveData['chapter_id'];
          final int appID = 753250804;
          final String appSign =
              '1346744a4d030550c13e5f924fcef9be48a6cc399a80ed4c577bb2d8deb60f63';

          return ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            userID: userID,
            userName: userName,
            liveID: liveID,
            config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          );
        },
      ),
    );
  }
}
