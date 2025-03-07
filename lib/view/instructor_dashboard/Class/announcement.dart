import 'package:flutter/material.dart';

class AnnouncementProvider with ChangeNotifier {
  final List<String> _announcements = []; // ✅ Store announcements

  List<String> get announcements =>
      _announcements; // ✅ Getter for announcements

  void updateAnnouncement(String text) {
    _announcements.add(text);
    notifyListeners(); // ✅ Notify UI
  }
}
