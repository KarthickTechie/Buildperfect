import 'package:dashboard/pages/home_screen.dart';
import 'package:dashboard/pages/split_screen.dart';
import 'package:dashboard/widgets/api_split_panel.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(MyApp());
  runApp(MyWidget());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation App',
      theme: ThemeData.light(),
      home: SplitScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
