/*
  @author   : karthick.d  06/10/2025
  @desc     : custom standard widget for textbox control
              use this widget in place of flutter textfield
              customized for consistant look and feel
              across the application
*/
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class KeyValueReactiveTextbox extends StatefulWidget {
  final double width;
  final String labeltext;
  final String formControlName;
  const KeyValueReactiveTextbox({
    super.key,
    required this.width,
    required this.labeltext,
    required this.formControlName,
  });

  @override
  State<KeyValueReactiveTextbox> createState() => _KeyValueTextboxState();
}

class _KeyValueTextboxState extends State<KeyValueReactiveTextbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: widget.width * 0.25,
            child: Text(
              widget.labeltext,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.width * 0.5,
          height: 25,

          child: ReactiveTextField<String>(
            formControlName: widget.formControlName,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
