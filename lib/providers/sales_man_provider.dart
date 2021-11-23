import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/sales_man.dart';

class SalesManProvider with ChangeNotifier {
  SalesMan? salesMan;

  Future<void> getSalesMan(String salesManId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://test-217c0-default-rtdb.europe-west1.firebasedatabase.app/salesMan.json'));
      salesMan = SalesMan.fromJson(response.body);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
