// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:music_player/themes/dark.dart';
import 'package:music_player/themes/light.dart';

class ThemeProvider extends ChangeNotifier{
  // default theme, light mode
  ThemeData _themeData = lightMode;

  //get theme 
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData==darkMode;

  // set theme
  set themeData(ThemeData themeData){
    _themeData = themeData;

  //update UI
  notifyListeners();
  }

  // toggle theme
  void toggleTheme(){
    if(_themeData == lightMode) {
      themeData = darkMode;
    }
    else {
      themeData = lightMode;
    }
  }
}