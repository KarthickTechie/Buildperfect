// ignore_for_file: public_member_api_docs, sort_constructors_first

part of './bpwidget_bloc.dart';

class BpwidgetState extends Equatable {
  final List<BPWidget>? bpWidgetsList;
  const BpwidgetState({this.bpWidgetsList});

  factory BpwidgetState.init() => BpwidgetState(
    bpWidgetsList: [
      BPWidget(
        bpwidgetProps: BpwidgetProps(
          label: '',
          controlName: '',
          controlType: '',
        ),
        widgetType: PlaceholderWidgets.Textfield,
      ),
    ],
  );

  @override
  List<Object?> get props => [bpWidgetsList];

  BpwidgetState copyWith({List<BPWidget>? bpWidgetsList}) {
    return BpwidgetState(bpWidgetsList: bpWidgetsList ?? this.bpWidgetsList);
  }
}
