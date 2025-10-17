import 'package:dashboard/appdata/forms/bpwidget_forms.dart';
import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/bloc/bpwidgets/bpwidget_bloc.dart';
import 'package:dashboard/bloc/bpwidgets/model/bpwidget.dart';
import 'package:dashboard/types/drag_drop_types.dart';
import 'package:dashboard/types/global_types.dart';
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
  final BPWidget? props;
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
      listener: (context, state) {
        if (state.saveStatus == SaveStatus.saved) {
          context.read<BpwidgetBloc>().add(
            BpwidgetLoadProps(
              bpWidget: BPWidget(
                bpwidgetProps: state.bpwidgetProps,
                // widgetType: PlaceholderWidgets.Textfield,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        print('PropsPanel => ${widget.props}');
        if (widget.props != null) {
          bpWidgetPropsForm.controls['label']?.updateValue(
            widget.props!.bpwidgetProps!.label,
          );
          bpWidgetPropsForm.controls['controlName']?.updateValue(
            widget.props!.bpwidgetProps!.controlName,
          );
          bpWidgetPropsForm.controls['controlType']?.updateValue(
            widget.props!.bpwidgetProps!.controlType,
          );

          bpWidgetPropsForm.controls['isRequired']?.updateValue(
            widget.props!.bpwidgetProps!.isRequired,
          );
          bpWidgetPropsForm.controls['min']?.updateValue(
            widget.props!.bpwidgetProps!.min,
          );
          bpWidgetPropsForm.controls['max']?.updateValue(
            widget.props!.bpwidgetProps!.max,
          );
          bpWidgetPropsForm.controls['isVerificationRequired']?.updateValue(
            widget.props!.bpwidgetProps!.isVerificationRequired,
          );
          bpWidgetPropsForm.controls['validationPatterns']?.updateValue(
            widget.props!.bpwidgetProps!.validationPatterns,
          );
        }
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
                      onChange: (val) {
                        bpWidgetPropsForm.controls['controlName']!.value =
                            widget.props!.bpwidgetProps!.controlName;
                        bpWidgetPropsForm.controls['controlName']!.patchValue(
                          '${bpWidgetPropsForm.controls['controlName']!.value}${val.value}',
                        );
                      },
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
                      dropdownEntries: ["true", "false"],
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
                        'None',
                      ],
                      width: widget.width,
                      labeltext: 'Validations',
                      onSelected: (value) {
                        print(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            print(
                              'bpWidgetPropsForm.value => ${bpWidgetPropsForm.value}',
                            );
                            // BpwidgetProps.fromMap({...bpWidgetPropsForm.value,'id':widget.props!.id});
                            context.read<BpwidgetPropsBloc>().add(
                              BPWidgetPropsSave(
                                props: BpwidgetProps.fromMap({
                                  ...bpWidgetPropsForm.value,
                                  'id': widget.props!.id,
                                }),
                              ),
                            );
                          },
                          label: Text('save'),
                          icon: Icon(Icons.save),
                        ),
                      ],
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
