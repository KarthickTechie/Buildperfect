// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author     :   karthick.d  13/10/2025
  @desc       :   event handler for saving actions for formcontrols

*/

part of 'bpwidget_action_bloc.dart';

abstract class BpwidgetActionEvent {}

class BpwidgetActionSave extends BpwidgetActionEvent {
  final BpwidgetAction bpwidgetAction;
  BpwidgetActionSave({required this.bpwidgetAction});
}
