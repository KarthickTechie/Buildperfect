/*
  @author    :   karthick.d    02/10/2025
  @desc      :   event class
*/

part of 'bpwidget_props_bloc.dart';

abstract class BpwidgetPropsEvent {}

class BPwidgetPropsInit extends BpwidgetPropsEvent {
  final BpwidgetProps props;
  BPwidgetPropsInit({required this.props});
}

class BPWidgetPropsSave extends BpwidgetPropsEvent {}
