import 'package:equatable/equatable.dart';

class ApiModel extends Equatable {
  final String apiName;
  final String apiEndpoint;
  final String apiMethodName;
  final String httpMethod;
  final List<Header> headers;
  final RequestObject requestKeys;
  final ApiResponse? responses;

  const ApiModel({
    required this.apiName,
    required this.apiEndpoint,
    required this.apiMethodName,
    required this.httpMethod,
    this.headers = const [],
    required this.requestKeys,
    this.responses,
  });

  // ======= JSON Deserialization =======
  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      apiName: json['apiName'] ?? '',
      apiEndpoint: json['apiEndpoint'] ?? '',
      apiMethodName: json['apiMethodName'] ?? '',
      httpMethod: json['httpMethod'] ?? '',
      headers:
          (json['headers'] as List<dynamic>?)
              ?.map((e) => Header.fromJson(e))
              .toList() ??
          [],
      requestKeys:
          json['requestKeys'] != null
              ? RequestObject.fromJson(
                Map<String, dynamic>.from(json['requestKeys']),
              )
              : const RequestObject({}),
      responses: json['responses'] != null
          ? ApiResponse.fromJson(json['responses'])
          : null,
    );
  }

  // ======= JSON Serialization =======
  Map<String, dynamic> toJson() {
    return {
      'apiName': apiName,
      'apiEndpoint': apiEndpoint,
      'apiMethodName': apiMethodName,
      'httpMethod': httpMethod,
      'headers': headers.map((h) => h.toJson()).toList(),
      'requestKeys': requestKeys.toJson(),
      'responses': responses?.toJson(),
    };
  }

  // ======= CopyWith =======
  ApiModel copyWith({
    String? apiName,
    String? apiEndpoint,
    String? apiMethodName,
    String? httpMethod,
    List<Header>? headers,
    RequestObject? requestKeys,
    ApiResponse? responses,
  }) {
    return ApiModel(
      apiName: apiName ?? this.apiName,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      apiMethodName: apiMethodName ?? this.apiMethodName,
      httpMethod: httpMethod ?? this.httpMethod,
      headers: headers ?? this.headers,
      requestKeys: requestKeys ?? this.requestKeys,
      responses: responses ?? this.responses,
    );
  }

  @override
  List<Object?> get props => [
    apiName,
    apiEndpoint,
    apiMethodName,
    httpMethod,
    headers,
    requestKeys,
    responses,
  ];
}

// ======= Header Class =======
class Header extends Equatable {
  final String key;
  final String value;

  const Header({required this.key, required this.value});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(key: json['key'] ?? '', value: json['value'] ?? '');
  }

  Map<String, dynamic> toJson() => {'key': key, 'value': value};

  @override
  List<Object?> get props => [key, value];
}

// ======= ResponseKey Class =======
class ApiResponse extends Equatable {
  final dynamic data;

  const ApiResponse({this.data});

  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(data: json);
  }

  dynamic toJson() => data;

  @override
  List<Object?> get props => [data];
}


// ======= RequestObject Class =======
class RequestObject extends Equatable {
  final Map<String, dynamic> request;

  const RequestObject(this.request);

  factory RequestObject.fromJson(Map<String, dynamic> json) =>
      RequestObject(Map<String, dynamic>.from(json));

  Map<String, dynamic> toJson() => request;

  RequestObject addNestedKey(String keys, dynamic value) {
    final newData = Map<String, dynamic>.from(request);
    frameNestedReqObject(newData, keys, value);
    return RequestObject(newData);
  }

  void frameNestedReqObject(
    Map<String, dynamic> obj,
    String keys,
    dynamic value,
  ) {
    final splittedKeys = keys.split(".");
    Map<String, dynamic> current = obj;
    for (int i = 0; i < splittedKeys.length; i++) {
      final key = splittedKeys[i];
      if (i == splittedKeys.length - 1) {
        current[key] = value;
      } else {
        if (current[key] == null || current[key] is! Map<String, dynamic>) {
          current[key] = <String, dynamic>{};
        }
        current = current[key];
      }
    }
  }

  void clearNestedReqObjectValues() {}

  @override
  List<Object?> get props => [request];
}
