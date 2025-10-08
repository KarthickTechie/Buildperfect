import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GlobalStyles {
  static BorderSide selectedBorderStyle = BorderSide(
    color: Colors.teal,
    width: 5.0,
    style: BorderStyle.solid,
  );

  static BorderSide unselectedBorderStyle = BorderSide(
    color: Colors.transparent,
  );
}
