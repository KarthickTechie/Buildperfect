/*

  @author     :   karthick.d    02/10/2025
  @desc       :   

 */
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/global_types.dart';

part 'bpwidget_props_event.dart';
part 'bpwidget_props_state.dart';

class BpwidgetPropsBloc extends Bloc<BpwidgetPropsEvent, BpwidgetPropsState> {
  BpwidgetPropsBloc() : super(BpwidgetPropsState.init()) {
    on<BPwidgetPropsInit>(onBPwidgetPropsInit);
    on<BPWidgetPropsSave>(onBPwidgetPropsSave);
  }

  Future<void> onBPwidgetPropsInit(BPwidgetPropsInit ev, Emitter emit) async {
    print('calling onBPwidgetPropsInit');
    emit(BpwidgetPropsState.init());
  }

  Future<void> onBPwidgetPropsSave(BPWidgetPropsSave ev, Emitter emit) async {
    print('calling onBPwidgetPropsSave => ${ev.props}');
    emit(state.copyWith(bpwidgetProps: ev.props, saveStatus: SaveStatus.saved));
  }
}
