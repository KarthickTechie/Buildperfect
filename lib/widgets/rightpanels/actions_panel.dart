import 'package:dashboard/appdata/forms/bpwidget_forms.dart';
import 'package:dashboard/bloc/bpwidgetaction/bloc/bpwidget_action_bloc.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/action/bpwidget_action.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/dataprovider/navigation_task_param.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/jobs/bpwidget_job.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/tasks/navigation_task.dart';
import 'package:dashboard/bloc/bpwidgets/bpwidget_bloc.dart';
import 'package:dashboard/bloc/bpwidgets/model/bpwidget.dart';
import 'package:dashboard/types/bpwidget_types.dart';
import 'package:dashboard/types/global_types.dart';
import 'package:dashboard/utils/math_utils.dart';
import 'package:dashboard/widgets/customcontrols/key_value_dropdown.dart';
import 'package:dashboard/widgets/customcontrols/key_value_reactive_dropdown.dart';
import 'package:dashboard/widgets/rightpanels/panel_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ActionsPanel extends StatefulWidget {
  final double width;
  final double height;
  final BPWidget? bpWidget;
  const ActionsPanel({
    super.key,
    required this.width,
    required this.height,
    required this.bpWidget,
  });

  @override
  State<ActionsPanel> createState() => _ActionsPanelState();
}

class _ActionsPanelState extends State<ActionsPanel> {
  late FormGroup actionform;
  late double initialHeight = widget.height + 100;
  double top = 0;
  double opac = 0;
  @override
  void initState() {
    super.initState();
    actionform = BpwidgetForms.get_bpwidgetaction_forms();
    top = initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BpwidgetActionBloc, BpwidgetActionState>(
      listener: (context, state) {
        // listens state change

        if (state.status == SaveStatus.saved) {
          print(
            'actionpanel bloc listener :: ${state.actionList[0].job.toString()}',
          );

          top = initialHeight;
          BPWidget bpWidget = widget.bpWidget!.copyWith(
            bpwidgetAction: state.actionList,
          );
          context.read<BpwidgetBloc>().add(
            BpwidgetLoadAction(bpWidget: bpWidget),
          );
        }
      },

      builder: (context, state) {
        /// set bpaction properties if configured from bpwidget from the
        /// widget property bpWidget

        if (widget.bpWidget == null) {
          actionform.reset();
        }

        if (widget.bpWidget != null &&
            widget.bpWidget!.bpwidgetAction != null) {
          BpwidgetAction action = widget.bpWidget!.bpwidgetAction![0];
          actionform.controls['event']!.patchValue(action.name);
          actionform.controls['action']!.patchValue(action.job.name);
          actionform.controls['pageurl']!.patchValue(
            action.job.taskDataprovider.url,
          );
        }

        return ReactiveForm(
          formGroup: actionform,
          child: Stack(
            children: [
              Positioned(
                child: Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Column(
                      children: [
                        PanelHeader(
                          panelWidth: widget.width,
                          title: 'Configure Formcontrol Actions',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                child: KeyValueReactiveDropdown(
                                  width: widget.width / 2,
                                  labeltext: 'Event',
                                  dropdownEntries: [
                                    BPEvent.onclick.name,
                                    BPEvent.onchange.name,
                                  ],
                                  formControlName: 'event',
                                ),
                              ),
                              SizedBox(
                                child: KeyValueReactiveDropdown(
                                  width: widget.width / 2,
                                  labeltext: 'Action',
                                  dropdownEntries: [
                                    Job.go.name,
                                    Job.gowithdata.name,
                                    Job.saveandgo.name,
                                  ],
                                  formControlName: 'action',
                                ),
                              ),

                              /// when click on setting show a fragment menu page
                              /// the form will open and user can configure Navigation
                              /// properties based on the selected action
                              SizedBox(
                                child: IconButton(
                                  onPressed: () {
                                    top = 0;
                                    opac = 1;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.blueAccent.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                top: top,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: opac,
                  curve: Curves.easeInOutBack,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 5),
                    child: Card(
                      color: Colors.white,
                      child: SizedBox(
                        width: widget.width,
                        height: widget.height,
                        child: Column(
                          children: [
                            PanelHeader(
                              panelWidth: widget.width,
                              title: 'Configure Navigation Properties',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: KeyValueReactiveDropdown(
                                      width: widget.width / 2,
                                      labeltext: 'GoTo',
                                      dropdownEntries: [
                                        'Home',
                                        'Dashboard',
                                        'Inbox',
                                        'NewLead',
                                      ],
                                      formControlName: 'pageurl',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final eventName =
                                      actionform.controls['event']!.value
                                          as String;

                                  final actionName =
                                      actionform.controls['action']!.value
                                          as String;
                                  final pageUrl =
                                      actionform.controls['pageurl']!.value
                                          as String;
                                  final id = MathUtils.generateUniqueID();

                                  final taskDataProvider =
                                      NavigationTaskDataProvider(url: pageUrl);
                                  final tasks = [
                                    NavigationTask(
                                      id: MathUtils.generateUniqueID(),
                                      name: Task.checkUrl.name,
                                    ),
                                    NavigationTask(
                                      id: MathUtils.generateUniqueID(),
                                      name: Task.navigation.name,
                                    ),
                                  ];
                                  final job = BPwidgetJob(
                                    type: BPActionJobTypes.Navigation.name,
                                    id: id,
                                    name: actionName,
                                    taskDataprovider: taskDataProvider,
                                    tasks: tasks,
                                  );

                                  final actionObj = BpwidgetAction(
                                    name: eventName,
                                    id: id,
                                    job: job,
                                  );
                                  context.read<BpwidgetActionBloc>().add(
                                    BpwidgetActionSave(
                                      bpwidgetAction: actionObj,
                                    ),
                                  );
                                  //setState(() {});
                                },
                                label: Row(
                                  children: [Icon(Icons.save), Text('Save')],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
