import 'package:flutter/material.dart';

class QueryProvider with ChangeNotifier {
  final List<String> _queries = [];

  List<String> get queries => _queries;

  void addQuery(String query) {
    _queries.add(query);
    notifyListeners();
  }
}
