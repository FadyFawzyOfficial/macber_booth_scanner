import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/visitor.dart';

class VisitorProvider with ChangeNotifier {
  Visitor? visitor;

  Future<void> getVisitor(String visitorId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://test-217c0-default-rtdb.europe-west1.firebasedatabase.app/visitor.json'));
      visitor = Visitor.fromJson(response.body);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
