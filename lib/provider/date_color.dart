
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Database.dart';

class ColorProvider with ChangeNotifier {
  // Declare the color map
  Map<DateTime, int> color = {};
  Database db = Database();

  // Method to increment the count for a specific date
  void incrementColor(DateTime date) {
    color.update(date, (count) => count + 1, ifAbsent: () => 1);
    print(color);
    notifyListeners();  // Notify listeners when the color map is updated
  }

}

