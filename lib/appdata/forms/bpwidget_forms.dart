import 'package:reactive_forms/reactive_forms.dart';

class BpwidgetForms {
  static FormGroup get_bpwidgetprops_forms() => FormGroup({
    'label': FormControl<String>(),
    'controlName': FormControl<String>(),
    'controlType': FormControl<String>(),
    'isRequired': FormControl<bool>(),
    'min': FormControl<String>(),
    'max': FormControl<String>(),
    'isVerificationRequired': FormControl<bool>(),
    'validationPatterns': FormControl<String>(),
  });
}
