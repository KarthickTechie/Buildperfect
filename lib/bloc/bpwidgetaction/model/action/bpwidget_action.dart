// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @author   :   karthick.d  13/10/2025
  @desc     :   configure action for formcontrol events which conprises of 
                actionid , and BPwidgetJob object

*/
import 'package:dashboard/bloc/bpwidgetaction/model/dataprovider/bpwidget_tasks_dataprovider.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/jobs/bpwidget_job.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/tasks/bpwidget_task.dart';

class BpwidgetAction {
  final String id;
  final String name;
  final BPwidgetJob job;
  BpwidgetAction({required this.name, required this.id, required this.job});

  factory BpwidgetAction.initWithId({required String id}) => BpwidgetAction(
    id: id,
    job: BPwidgetJob(
      type: '',
      id: id,
      name: '',
      taskDataprovider: BPTaskDataprovider(url: ''),
      tasks: <BPwidgetTask>[],
    ),
    name: '',
  );

  @override
  String toString() => 'BpwidgetAction(id: $id, name: $name, job: $job)';
}
