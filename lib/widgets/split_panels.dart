/*
    @auth     : karthick.d    06/10/2025
    @desc     : parent container for all the three panel
                split_panel
                  items_panel

*/
import 'dart:math';

import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/drag_drop_types.dart';
import 'package:dashboard/widgets/item_panel.dart';
import 'package:dashboard/widgets/my_drop_region.dart';
import 'package:dashboard/widgets/right_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplitPanel extends StatefulWidget {
  final int columns;
  final double itemSpacing;
  const SplitPanel({super.key, this.columns = 3, this.itemSpacing = 2.0});

  @override
  State<SplitPanel> createState() => _SplitPanelState();
}

class _SplitPanelState extends State<SplitPanel> {
  final List<PlaceholderWidgets> upper = [];
  final List<PlaceholderWidgets> lower = [
    PlaceholderWidgets.Textfield,
    PlaceholderWidgets.Dropdown,
    PlaceholderWidgets.Checkbox,
    PlaceholderWidgets.Radio,
    PlaceholderWidgets.Button,
    PlaceholderWidgets.Label,
  ];

  PanelLocation dragStart = (-1, Panel.lower);
  PanelLocation? dropPreview;

  PlaceholderWidgets? hoveringData;
  BpwidgetProps selectedWidget = BpwidgetProps(
    label: '',
    controlName: '',
    controlType: '',
  );

  /// this method is called when the itemplaceholder is dragged
  /// it's set  the state -> dragStart and data state properties
  ///
  void onItemDragStart(PanelLocation start) {
    final data = switch (start.$2) {
      Panel.upper => upper[start.$1],
      Panel.lower => lower[start.$1],
    };

    setState(() {
      dragStart = start;
      hoveringData = data;
    });
  }

  void updateDropPreview(PanelLocation update) => setState(() {
    dropPreview = update;
  });

  void drop() {
    setState(() {
      if (dropPreview!.$2 == Panel.upper) {
        upper.insert(max(dropPreview!.$1, upper.length), hoveringData!);
      }
    });
  }

  void onItemClickRef(BpwidgetProps widget) {
    selectedWidget = widget;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BuildPerfect'), elevation: 2),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final gutter = widget.columns + 1;
          final spaceForColumns =
              constraints.maxWidth - (widget.itemSpacing * gutter);
          final columnWidth = spaceForColumns / widget.columns;
          final itemSize = Size(columnWidth, columnWidth);
          final leftPanelWidth = constraints.maxWidth / 4;
          final centerPanelWidth = constraints.maxWidth / 2;
          final rightPanelWidth =
              constraints.maxWidth - (leftPanelWidth + centerPanelWidth);
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Stack(
              children: [
                Positioned(
                  // for draggable component
                  width: leftPanelWidth - 100,
                  height: constraints.maxHeight,
                  left: 0,
                  child: MyDropRegion(
                    onDrop: drop,
                    updateDropPreview: updateDropPreview,
                    childSize: itemSize,
                    columns: widget.columns,
                    panel: Panel.lower,

                    child: ItemPanel(
                      crossAxisCount: widget.columns,
                      spacing: widget.itemSpacing,
                      items: lower,
                      onDragStart: onItemDragStart,
                      panel: Panel.lower,
                      dragStart: dragStart,
                      dropPreview: dropPreview,
                      hoveringData: hoveringData,
                    ),
                  ),
                ),
                Positioned(
                  width: 2,
                  height: constraints.maxHeight,
                  left: leftPanelWidth,
                  child: ColoredBox(color: Colors.black),
                ),
                Positioned(
                  // centerpanel for dragtarget
                  width: centerPanelWidth,
                  height: constraints.maxHeight,
                  left: leftPanelWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                    child: MyDropRegion(
                      onDrop: drop,
                      updateDropPreview: updateDropPreview,
                      childSize: itemSize,
                      columns: widget.columns,
                      panel: Panel.upper,
                      child: ItemPanel(
                        crossAxisCount: widget.columns,
                        spacing: widget.itemSpacing,
                        items: upper,
                        onDragStart: onItemDragStart,
                        panel: Panel.upper,
                        dragStart: dragStart,
                        dropPreview: dropPreview,
                        hoveringData: hoveringData,
                        onItemClicked: onItemClickRef,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: rightPanelWidth,
                  height: constraints.maxHeight,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.pink.shade100),

                    /// RightPanel - is parent model for props , action and
                    /// datasource panel
                    child: RightPanel(
                      width: rightPanelWidth,
                      height: constraints.maxHeight,
                      props: selectedWidget,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
