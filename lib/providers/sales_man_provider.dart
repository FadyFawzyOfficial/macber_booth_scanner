import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/sales_man.dart';

class SalesManProvider with ChangeNotifier {
  SalesMan? salesMan;

  Future<void> getSalesMan(String salesManId) async {
    try {
      final response = await http.get(Uri.parse(''));
      salesMan = SalesMan.fromJson(response.body);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
