import 'package:dashboard/appstyles/global_styles.dart';
import 'package:dashboard/widgets/rupeeformatter.dart';
import 'package:flutter/material.dart';

// currency field widget
class CurrencyField extends StatefulWidget {
  final bool? enabled;
  final String? hintText;
  final String? lable;
  final TextEditingController? formController;
  final ValueChanged<String>? onChanged;

  const CurrencyField({
    super.key,
    this.enabled,
    this.lable,
    this.hintText,
    this.formController,
    this.onChanged,
  });

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.formController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.formController == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [Rupeeformatter()],
      onChanged: widget.onChanged,
      decoration: InputDecoration(hintText: widget.hintText, prefixText: '₹ '),
    );
  }
}
