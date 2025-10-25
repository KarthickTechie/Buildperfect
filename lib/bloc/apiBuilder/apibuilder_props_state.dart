import 'package:dashboard/bloc/apiBuilder/model/apibuilder_props.dart';
import 'package:equatable/equatable.dart';

class ApiState extends Equatable {
  final List<ApiModel> apis;

  const ApiState({this.apis = const []});

  ApiState copyWith({List<ApiModel>? apis}) {
    return ApiState(apis: apis ?? this.apis);
  }

  @override
  List<Object?> get props => [apis];
}
