import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes.dart';


class Classwisechapter extends StatefulWidget {
  final int dataId;
  const Classwisechapter({super.key, required this.dataId});

  @override
  State<Classwisechapter> createState() => _ClasswisechapterState();
}

class _ClasswisechapterState extends State<Classwisechapter> {
  List<Map<String, dynamic>> chapters = [];
  bool isLoading = true;
  String? authToken;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetchChapters();
  }

  Future<void> loadTokenAndFetchChapters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    if (authToken != null) {
      await fetchChapters();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchChapters() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/classroom/${widget.dataId}/chapters',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> rawChapters = response.data['chapters'];
        setState(() {
          chapters = rawChapters.map((chapter) {
            return {
              "id": chapter['id'],
              "title": chapter['title'],
              "description": chapter['description'] ?? "No description provided",
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching chapters: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToChapterDetails(int chapterId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Classes(chapterId: chapterId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          height: 130,
          width: double.infinity,
          color: const Color.fromRGBO(43, 92, 116, 1),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 15),
                const Text(
                  "All Chapters",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chapters.isEmpty
          ? const Center(child: Text("No chapters found"))
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return GestureDetector(
              onTap: () => navigateToChapterDetails(chapter['id']),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: const Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  title: Text(
                    'Chapter: ${chapter['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      chapter['description'],
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
