import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveClasses extends StatefulWidget {
  final String classId; // Accept classId from InstructorClass

  const LiveClasses({Key? key, required this.classId}) : super(key: key);

  @override
  State<LiveClasses> createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  late Future<Map<String, dynamic>> _liveDataFuture;

  @override
  void initState() {
    super.initState();
    _liveDataFuture = fetchLiveStreamData();
  }

  Future<Map<String, dynamic>> fetchLiveStreamData() async {
    try {
      Dio dio = Dio();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        'https://admin.uthix.com/api/class/start',
        data: {
          "chapter_id": widget.classId, // ✅ Posting classId
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Live stream data: ${response.data}");
        return response.data;
      } else {
        throw Exception("Failed to fetch live stream data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Class - Teacher",
          style: TextStyle(color: Colors.black),
        ),
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
          final String userName = liveData['teacher_name'] ?? 'Teacher';
          final String liveID = liveData['chapter_id'];
          final int appID = 753250804; // Your ZegoCloud App ID
          final String appSign =
              '1346744a4d030550c13e5f924fcef9be48a6cc399a80ed4c577bb2d8deb60f63'; // Your App Sign

          return ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            userID: userID,
            userName: userName,
            liveID: liveID,
            config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
          );
        },
      ),
    );
  }
}