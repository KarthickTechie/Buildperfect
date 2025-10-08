import 'package:dashboard/appdata/forms/bpwidget_forms.dart';
import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/widgets/customcontrols/key_value_dropdown.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_dropdown.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_textbox.dart';
import 'package:dashboard/widgets/customcontrols/key_value_textbox.dart';
import 'package:dashboard/widgets/rightpanels/panel_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PropsPanel extends StatefulWidget {
  final double width;
  final double height;
  final BpwidgetProps? props;
  const PropsPanel({
    super.key,
    required this.width,
    required this.height,
    required this.props,
  });

  @override
  State<PropsPanel> createState() => _PropsPanelState();
}

class _PropsPanelState extends State<PropsPanel> {
  late final FormGroup bpWidgetPropsForm;
  final dropDownTextStyle = TextStyle(fontSize: 12);
  _PropsPanelState() : super();

  @override
  void initState() {
    bpWidgetPropsForm = BpwidgetForms.get_bpwidgetprops_forms();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BpwidgetPropsBloc, BpwidgetPropsState>(
      listener: (context, state) {},
      builder: (context, state) {
        print('PropsPanel => ${state.bpwidgetProps}');
        bpWidgetPropsForm.controls['label']?.updateValue(widget.props!.label);
        bpWidgetPropsForm.controls['controlName']?.updateValue(
          state.bpwidgetProps.controlName +
              bpWidgetPropsForm.controls["label"]!.value.toString(),
        );
        bpWidgetPropsForm.controls['controlType']?.updateValue(
          widget.props!.controlType,
        );

        return ReactiveForm(
          formGroup: bpWidgetPropsForm,
          child: Card(
            color: Colors.white,
            child: SizedBox(
              width: widget.width,
              height: widget.height,

              child: Column(
                children: [
                  PanelHeader(
                    panelWidth: widget.width,
                    title: 'Configure Formcontrol Properties',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveTextbox(
                      labeltext: 'Label',
                      width: widget.width,
                      formControlName: 'label',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveTextbox(
                      labeltext: 'Control Name',
                      width: widget.width,
                      formControlName: 'controlName',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveTextbox(
                      width: widget.width,
                      labeltext: 'Control Type',
                      formControlName: 'controlType',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveDropdown(
                      width: widget.width,
                      labeltext: 'Required ?',
                      dropdownEntries: ['true', 'false'],
                      onSelected: (value) {
                        print('required ? => $value');
                      },
                      formControlName: 'isRequired',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveDropdown(
                      width: widget.width,
                      labeltext: 'Verification Required ?',
                      dropdownEntries: ['true', 'false'],
                      formControlName: 'isVerificationRequired',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveTextbox(
                      width: widget.width,
                      labeltext: 'Minlength',
                      formControlName: 'min',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveTextbox(
                      width: widget.width,
                      labeltext: 'Maxlength',
                      formControlName: 'max',
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KeyValueReactiveDropdown(
                      formControlName: 'validationPatterns',
                      dropdownEntries: [
                        'Email',
                        'Phone',
                        'PAN',
                        'Aadhaar',
                        'DL',
                        'VoterID',
                        'Passport',
                        'GST',
                        'UPI',
                      ],
                      width: widget.width,
                      labeltext: 'Validations',
                      onSelected: (value) {
                        print(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
