// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author   :   karthick.d  08/10/2025
  @desc     :   event handler for BPWidgets

*/

part of './bpwidget_bloc.dart';

abstract class BpwidgetEvent {}

class BpwidgetLoadProps extends BpwidgetEvent {
  final BPWidget? bpWidget;
  BpwidgetLoadProps({this.bpWidget});
}

class BpwidgetLoadAction extends BpwidgetEvent {
  final BPWidget? bpWidget;
  BpwidgetLoadAction({this.bpWidget});
}
