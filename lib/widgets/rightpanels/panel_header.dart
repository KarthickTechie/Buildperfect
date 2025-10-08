/*
    @author     : karthick.d    02/10/2025
    @desc       : Reusable wiget that draws header and botton border 
                  required params - panelWidth and title string 
                  panelwidth is passed from parent widget
*/
import 'package:flutter/material.dart';

class PanelHeader extends StatelessWidget {
  final double panelWidth;
  final String title;
  const PanelHeader({required this.panelWidth, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          width: panelWidth,
          height: 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
          ),
        ),
      ],
    );
  }
}
