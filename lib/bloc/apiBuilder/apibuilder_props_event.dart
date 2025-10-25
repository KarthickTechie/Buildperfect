import 'package:dashboard/bloc/apiBuilder/model/apibuilder_props.dart';
import 'package:equatable/equatable.dart';

abstract class ApiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadApis extends ApiEvent {}

class AddApi extends ApiEvent {
  final ApiModel api;
  AddApi(this.api);

  @override
  List<Object?> get props => [api];
}

class EditApi extends ApiEvent {
  final int index;
  final ApiModel api;
  EditApi(this.index, this.api);

  @override
  List<Object?> get props => [index, api];
}

class DeleteApi extends ApiEvent {
  final int index;
  DeleteApi(this.index);

  @override
  List<Object?> get props => [index];
}
