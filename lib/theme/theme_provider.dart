import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = dark;
  ThemeData get themeData => _themeData;
  bool get isDark => _themeData == dark;
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }
  void toogleTheme(){
    if(_themeData == light){
      themeData = dark;
    }
    else{
      themeData = light;
    }
  }
}