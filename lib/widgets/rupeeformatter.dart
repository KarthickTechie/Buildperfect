import 'package:dashboard/utils.dart';
import 'package:flutter/services.dart';

class Rupeeformatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Removes all non digit characters and extracts only digits
    String raw = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    print('Rupeeformatter-raw $raw');

    if (raw.isEmpty) return newValue;

    // Extract last 3 digits then extract remaining digits before the last 3 digits
    // then group the remaining digits in 2s from the end
    String finalValue = formatAmount(raw);
    return TextEditingValue(
      text: finalValue,
      selection: TextSelection.collapsed(offset: finalValue.length),
    );
  }
}
