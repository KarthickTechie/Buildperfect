// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author     :     karthick.d     13/10/2025
  @desc       :     BPWidget action state will have state object for 
                    BPWidgetaction , one BPWidget can have array of 
                    BPWidgetAction. each associated to formcontrolevent
                    
                    BpWidget.onclick , BPWidget.onchange etc
*/

part of 'bpwidget_action_bloc.dart';

class BpwidgetActionState extends Equatable {
  final List<BpwidgetAction> actionList;
  final SaveStatus status;
  BpwidgetActionState({required this.actionList, required this.status});

  factory BpwidgetActionState.init() =>
      BpwidgetActionState(actionList: [], status: SaveStatus.init);

  @override
  // TODO: implement props
  List<Object?> get props => [actionList, status];

  BpwidgetActionState copyWith({List<BpwidgetAction>? actionList}) {
    return BpwidgetActionState(
      actionList: actionList ?? this.actionList,
      status: SaveStatus.saved,
    );
  }
}
