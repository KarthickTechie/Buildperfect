import 'package:flutter/material.dart';

class GlobalColors {
  // static Color centerPanelBGColor = Colors.blue.withAlpha(60);
  static Color iconColorWhite = Colors.white;
  static TextStyle titleTextStyleWhite = TextStyle(color:Colors.white,fontWeight: FontWeight.w600);
  static IconThemeData navSelectIcomeThem = IconThemeData(size: 24,color: Color.fromARGB(255, 17, 153, 153));
  static Color navIndicatorColor =Color.fromARGB(255, 161, 235, 235);
  static Color navBGColor = Colors.white;
  static Color leftPanelBGColor = Colors.white;
  static Color centerPanelBGColor = Color(0xFFF4F5F9);
  static IconThemeData iconThemeWhite = IconThemeData(color: Colors.white,weight:600);
  static LinearGradient appBarBGColor = LinearGradient(
    colors: [
      Color(0xFF00C9A7), // Cyan/turquoise
      Color(0xFF6A11CB), // Purple
    ],
  );
}
