/*
@author     :   karthick.d  30/09/2025
@desc       :   rightpanel contains the components for configuring UDF (user defined fields)
                right panel have segment button for configuration segments
                conf segment 1 - properties 
                     {properties} segment wraps formcontrol properties
                     {action}     segment wraps formcontrols events
                     {datasource} segment wraps datasource for dropdown fields
                the above three components encaps in widgets 
                [FormControlProperties] - wraps all controls for props conf
                [FormControlActions]    - wraps all controls for events conf
                [FormControlDataSource] - wraps all controls for control's DS
*/
import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/ui_controls_types.dart';
import 'package:dashboard/widgets/page_props_button_segment.dart';
import 'package:dashboard/widgets/rightpanels/actions_panel.dart';
import 'package:dashboard/widgets/rightpanels/datasource.dart';
import 'package:dashboard/widgets/rightpanels/props_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RightPanel extends StatefulWidget {
  /// onSegmentButtonClicked method send the current tab
  /// based on that loan propspanel , actionpanel and datapanel widget
  final double width;
  final double height;
  final BpwidgetProps? props;
  const RightPanel({
    super.key,
    required this.width,
    required this.height,
    required this.props,
  });

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  late double panelWidth = widget.width;
  double gutterHeight = 70;
  late double panelHeight = widget.height - gutterHeight;
  Set<PagePropsSegmentButton> selectedSegmentButton = {
    PagePropsSegmentButton.property,
  };

  @override
  void initState() {
    super.initState();
  }

  void _segementButtonChangedListener(
    Set<PagePropsSegmentButton> selectedSegment,
  ) {
    print(selectedSegment.single);
    selectedSegmentButton = selectedSegment;
    setState(() {});
  }

  Widget renderPanelsBasedOnSegment() {
    return switch (selectedSegmentButton.first) {
      PagePropsSegmentButton.property => PropsPanel(
        width: panelWidth,
        height: panelHeight,
        props: widget.props,
      ),
      PagePropsSegmentButton.action => ActionsPanel(
        width: panelWidth,
        height: panelHeight,
      ),
      PagePropsSegmentButton.datasource => DatasourcePanel(
        width: panelWidth,
        height: panelHeight,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BpwidgetPropsBloc(), lazy: false),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            PagePropsButtonSegment(
              onSegmentChanged: _segementButtonChangedListener,
            ),
            renderPanelsBasedOnSegment(),
          ],
        ),
      ),
    );
  }
}
