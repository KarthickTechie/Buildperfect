/*
  @author     : karthick.d  07/10/2025
  @desc       : DraggableHolder widget is that wraps the dragged formcontrol
                inside a stack widget and a label container , you can use this 
                widget to stack any widget u need above or below the dragged
                form control
*/
import 'package:flutter/material.dart';

class DraggedHolder extends StatefulWidget {
  final String labelText;
  final Widget child;
  final VoidCallback? onTapDraggedControl;
  const DraggedHolder({
    super.key,
    required this.labelText,
    required this.child,
    this.onTapDraggedControl,
  });

  @override
  State<DraggedHolder> createState() => _DraggedHolderState();
}

class _DraggedHolderState extends State<DraggedHolder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapDraggedControl,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            constraints: BoxConstraints(minWidth: 100, maxHeight: 15),
            child: Center(
              child: Text(
                widget.labelText,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Center(child: widget.child),
          // TextField(
          //   enabled: false,
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(),
          //     hintText: 'Textbox',
          //     label: Text('TextField'),
          //     floatingLabelStyle: TextStyle(fontSize: 14),
          //   ),
          // ),
        ],
      ),
    );
  }
}
