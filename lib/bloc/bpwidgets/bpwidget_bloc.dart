/*
  @author   : karthick.d   08/10/2025
  @desc     : bloc provided bpwidget state and handles event BPWidgetProps,
              BPWidgetActions and BPWidgetDataSource
*/

import 'package:bloc/bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/drag_drop_types.dart';
import 'package:equatable/equatable.dart';

import 'package:dashboard/bloc/bpwidgets/model/bpwidget.dart';

part './bpwidget_state.dart';
part './bpwidget_event.dart';

class BpwidgetBloc extends Bloc<BpwidgetEvent, BpwidgetState> {
  BpwidgetBloc() : super(BpwidgetState.init()) {
    on<BpwidgetLoadProps>(onBpwidgetLoadProps);
    on<BpwidgetLoadAction>(onBpwidgetLoadActions);
  }

  Future<void> onBpwidgetLoadProps(BpwidgetLoadProps ev, Emitter emit) async {
    emit(state.copyWith(bpWidgetsList: List.from([ev.bpWidget])));
  }

  Future<void> onBpwidgetLoadActions(
    BpwidgetLoadAction ev,
    Emitter emit,
  ) async {
    emit(state.copyWith(bpWidgetsList: List.from([ev.bpWidget])));
  }
}
