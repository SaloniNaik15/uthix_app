import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_personalChat.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? accessLoginToken;

  final Dio _dio = Dio();
  final String _apiUrl = "https://admin.uthix.com/api/get-all-user";

  @override
  void initState() {
    super.initState();
    _initializeData();
    _controller.addListener(_onSearchChanged);
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await _fetchContacts();
  }

  void _onSearchChanged() {
    _fetchContacts(_controller.text); // Fetch contacts based on input
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
  }

  List<Map<String, dynamic>> allStudContacts = []; // Store full user data
  List<Map<String, dynamic>> filteredContacts = [];

  Future<void> _fetchContacts([String query = ""]) async {
    try {
      String searchUrl = _apiUrl;
      if (query.isNotEmpty) {
        searchUrl = "$_apiUrl?name=$query";
      }

      Response response = await _dio.get(
        searchUrl,
        options:
            Options(headers: {"Authorization": "Bearer $accessLoginToken"}),
      );

      if (response.statusCode == 200) {
        List<dynamic> users = response.data["users"];
        setState(() {
          allStudContacts = users
              .map((user) => {
                    "id": user["id"], // ✅ Store user ID
                    "name": user["name"]
                  })
              .toList();

          filteredContacts = List.from(allStudContacts);
        });
      }
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildRecipientInput(),
            const SizedBox(height: 20),
            _buildSuggestionsTitle(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildSuggestionItem(filteredContacts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 25),
      child: Row(
        children: [
          _buildIcon(
              Icons.arrow_back_ios_outlined, () => Navigator.pop(context)),
          const SizedBox(width: 15),
          Text(
            "New Chat",
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(43, 92, 116, 1),
            ),
          ),
          const Spacer(),
          _buildIcon(Icons.search, () {}),
        ],
      ),
    );
  }

  Widget _buildRecipientInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            "To:",
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Enter recipient",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Suggestions",
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(Map<String, dynamic> user) {
    return InkWell(
      onTap: () {
        int conversationId = user["id"]; // ✅ Pass as conversationId

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudPersonalchat(conversationId: conversationId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    child: Image.asset("assets/login/profile.jpeg",
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user["name"],
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SizedBox(width: 60),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Color.fromRGBO(246, 246, 245, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, size: 25), onPressed: onTap);
  }
}
