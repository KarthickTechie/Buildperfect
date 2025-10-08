// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'bpwidget_props_bloc.dart';

class BpwidgetPropsState extends Equatable {
  final BpwidgetProps bpwidgetProps;
  final SaveStatus? saveStatus;

  const BpwidgetPropsState(this.saveStatus, {required this.bpwidgetProps});

  @override
  List<Object> get props => [bpwidgetProps];

  @override
  bool get stringify => true;

  BpwidgetPropsState copyWith({
    BpwidgetProps? bpwidgetProps,
    SaveStatus? saveStatus,
  }) {
    return BpwidgetPropsState(
      bpwidgetProps: bpwidgetProps ?? this.bpwidgetProps,
      saveStatus ?? this.saveStatus,
    );
  }

  factory BpwidgetPropsState.init() => BpwidgetPropsState(
    bpwidgetProps: BpwidgetProps(
      label: 'label1',
      controlName: 'page1_',
      controlType: 'textbox',
    ),
    SaveStatus.init,
  );
}
