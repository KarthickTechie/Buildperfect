import 'package:dashboard/bloc/apiBuilder/apibuilder_props_event.dart';
import 'package:dashboard/bloc/apiBuilder/apibuilder_props_state.dart';
import 'package:dashboard/bloc/apiBuilder/model/apibuilder_props.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(const ApiState()) {
    on<LoadApis>((event, emit) => emit(state));
    on<AddApi>((event, emit) {
      final updatedApis = List<ApiModel>.from(state.apis)..add(event.api);
      emit(state.copyWith(apis: updatedApis));
    });
    on<EditApi>((event, emit) {
      final updatedApis = List<ApiModel>.from(state.apis);
      if (event.index >= 0 && event.index < updatedApis.length) {
        updatedApis[event.index] = event.api;
        emit(state.copyWith(apis: updatedApis));
      }
    });
    on<DeleteApi>((event, emit) {
      final updatedApis = List<ApiModel>.from(state.apis);
      if (event.index >= 0 && event.index < updatedApis.length) {
        updatedApis.removeAt(event.index);
        emit(state.copyWith(apis: updatedApis));
      }
    });
  }
}
