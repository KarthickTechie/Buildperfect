/*
  @author     :   karthick.d  09/10/2025
  @desc
*/
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dashboard/bloc/bpwidgetaction/model/action/bpwidget_action.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/drag_drop_types.dart';

class BPWidget {
  final PlaceholderWidgets? widgetType;
  final String? id;
  BpwidgetProps? bpwidgetProps;
  List<BpwidgetAction>? bpwidgetAction;
  BPWidget({this.widgetType, this.id, this.bpwidgetProps, this.bpwidgetAction});

  BPWidget copyWith({
    PlaceholderWidgets? widgetType,
    String? id,
    BpwidgetProps? bpwidgetProps,
    List<BpwidgetAction>? bpwidgetAction,
  }) {
    return BPWidget(
      widgetType: widgetType ?? this.widgetType,
      id: id ?? this.id,
      bpwidgetProps: bpwidgetProps ?? this.bpwidgetProps,
      bpwidgetAction: bpwidgetAction ?? this.bpwidgetAction,
    );
  }
}
