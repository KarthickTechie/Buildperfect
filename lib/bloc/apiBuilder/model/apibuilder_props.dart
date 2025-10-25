import 'package:equatable/equatable.dart';
 
class ApiModel extends Equatable {
  final String apiName;
  final String apiEndpoint;
  final String apiMethodName;
  final String httpMethod;
  final List<Header> headers;
  final List<RequestKey> requestKeys;
  final List<ResponseKey> responses;
 
  const ApiModel({
    required this.apiName,
    required this.apiEndpoint,
    required this.apiMethodName,
    required this.httpMethod,
    this.headers = const [],
    this.requestKeys = const [],
    this.responses = const [],
  });
 
  // ======= JSON Deserialization =======
  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      apiName: json['apiName'] ?? '',
      apiEndpoint: json['apiEndpoint'] ?? '',
      apiMethodName: json['apiMethodName'] ?? '',
      httpMethod: json['httpMethod'] ?? '',
      headers: (json['headers'] as List<dynamic>?)
              ?.map((e) => Header.fromJson(e))
              .toList() ??
          [],
      requestKeys: (json['requestKey'] as List<dynamic>?)
              ?.map((e) => RequestKey.fromJson(e))
              .toList() ??
          [],
      responses: (json['responses'] as List<dynamic>?)
              ?.map((e) => ResponseKey.fromJson(e))
              .toList() ??
          [],
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
      'requestKey': requestKeys.map((r) => r.toJson()).toList(),
      'responses': responses.map((r) => r.toJson()).toList()
    };
  }
 
  // ======= CopyWith =======
  ApiModel copyWith({
    String? apiName,
    String? apiEndpoint,
    String? apiMethodName,
    String? httpMethod,
    List<Header>? headers,
    List<RequestKey>? requestKeys,
    List<ResponseKey>? responses,
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
  List<Object?> get props =>
      [apiName, apiEndpoint, apiMethodName, httpMethod, headers, requestKeys, responses];
}
 
// ======= Header Class =======
class Header extends Equatable {
  final String key;
  final String value;
 
  const Header({required this.key, required this.value});
 
  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
 
  Map<String, dynamic> toJson() => {'key': key, 'value': value};
 
  @override
  List<Object?> get props => [key, value];
}
 
// ======= RequestKey Class =======
class RequestKey extends Equatable {
  final String key;
  final String value;
 
  const RequestKey({required this.key, required this.value});
 
  factory RequestKey.fromJson(Map<String, dynamic> json) {
    return RequestKey(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
 
  Map<String, dynamic> toJson() => {'key': key, 'value': value};
 
  @override
  List<Object?> get props => [key, value];
}
 
// ======= ResponseKey Class =======
class ResponseKey extends Equatable {
  final String key;
  final String value;
 
  const ResponseKey({required this.key, required this.value});
 
  factory ResponseKey.fromJson(Map<String, dynamic> json) {
    return ResponseKey(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
 
  Map<String, dynamic> toJson() => {'key': key, 'value': value};
 
  @override
  List<Object?> get props => [key, value];
}