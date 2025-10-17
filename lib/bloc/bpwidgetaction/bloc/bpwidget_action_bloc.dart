/*
  @author     :     karthick.d  13/10/2025
  @desc       :     bloc handlers for BPwidgetaction save , if any actions are
                    saved the same will be added in BPWidget action property

                    
*/

import 'package:dashboard/bloc/bpwidgetaction/model/action/bpwidget_action.dart';
import 'package:dashboard/types/global_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './bpwidget_action_state.dart';
part './bpwidget_action_event.dart';

class BpwidgetActionBloc
    extends Bloc<BpwidgetActionEvent, BpwidgetActionState> {
  BpwidgetActionBloc() : super(BpwidgetActionState.init()) {
    // event handler
    on<BpwidgetActionSave>(_bpwidgetActionSave);
  }

  Future<void> _bpwidgetActionSave(
    BpwidgetActionSave event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        actionList: List.from([
          ...state.actionList,
          ...[event.bpwidgetAction],
        ]),
      ),
    );
  }
}
