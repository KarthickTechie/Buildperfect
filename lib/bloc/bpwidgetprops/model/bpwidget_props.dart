// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dashboard/types/ui_controls_types.dart';

/*
  @author     :   karthick.d  02/10/2025
  @desc       :   BpWidgetProps data class for 
                  formcontrol prperties 
                  { String label , String controlname , String controltype, 
                    String controlId , bool isRequired , int max  , int min
                    String isVerificationRequired , <enum ValidationProps>[]
*/

class BpwidgetProps {
  final String label;
  final String controlName;
  final String controlType;
  final String isRequired;
  final String? max;
  final String? min;
  final String isVerificationRequired;
  final String? validationPatterns;
  final String? id;
  BpwidgetProps({
    required this.label,
    required this.controlName,
    required this.controlType,
    this.isRequired = "false",
    this.max,
    this.min,
    this.isVerificationRequired = "false",
    this.validationPatterns,
    this.id,
  });

  BpwidgetProps copyWith({
    String? label,
    String? controlName,
    String? controlType,
    String? isRequired,
    String? max,
    String? min,
    String? isVerificationRequired,
    String? validationPatterns,
    String? id,
  }) {
    return BpwidgetProps(
      label: label ?? this.label,
      controlName: controlName ?? this.controlName,
      controlType: controlType ?? this.controlType,
      isRequired: isRequired ?? this.isRequired,
      max: max ?? this.max,
      min: min ?? this.min,
      isVerificationRequired:
          isVerificationRequired ?? this.isVerificationRequired,
      validationPatterns: validationPatterns ?? this.validationPatterns,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'controlName': controlName,
      'controlType': controlType,
      'isRequired': isRequired,
      'max': max,
      'min': min,
      'isVerificationRequired': isVerificationRequired,
      'validationPatterns': validationPatterns,
      'id': id,
    };
  }

  factory BpwidgetProps.fromMap(Map<String, dynamic> map) {
    return BpwidgetProps(
      label: map['label'] as String,
      controlName: map['controlName'] as String,
      controlType: map['controlType'] as String,
      isRequired: map['isRequired'] as String,
      max: map['max'] != null ? map['max'] as String : null,
      min: map['min'] != null ? map['min'] as String : null,
      isVerificationRequired: map['isVerificationRequired'] as String,
      validationPatterns:
          map['validationPatterns'] != null
              ? map['validationPatterns'] as String
              : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BpwidgetProps.fromJson(String source) =>
      BpwidgetProps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BpwidgetProps(label: $label, controlName: $controlName, controlType: $controlType, isRequired: $isRequired, max: $max, min: $min, isVerificationRequired: $isVerificationRequired, validationPatterns: $validationPatterns, id: $id)';
  }

  @override
  bool operator ==(covariant BpwidgetProps other) {
    if (identical(this, other)) return true;

    return other.label == label &&
        other.controlName == controlName &&
        other.controlType == controlType &&
        other.isRequired == isRequired &&
        other.max == max &&
        other.min == min &&
        other.isVerificationRequired == isVerificationRequired &&
        other.validationPatterns == validationPatterns &&
        other.id == id;
  }

  @override
  int get hashCode {
    return label.hashCode ^
        controlName.hashCode ^
        controlType.hashCode ^
        isRequired.hashCode ^
        max.hashCode ^
        min.hashCode ^
        isVerificationRequired.hashCode ^
        validationPatterns.hashCode ^
        id.hashCode;
  }
}
