/*
  @author     :   karthick.d  13/10/2025
  @desc       :   object for job information , the job is a collection of tasks
                  data is a dataprovider for running task
                  example : if checkpage task is running then the task will look
                  up pageurl property in dataprovider 
                  similarly if checkFormData task is running then 
*/

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dashboard/bloc/bpwidgetaction/model/tasks/bpwidget_task.dart';
import 'package:dashboard/bloc/bpwidgetaction/model/dataprovider/bpwidget_tasks_dataprovider.dart';

class BPwidgetJob {
  String type;
  String id;
  String name;
  BPTaskDataprovider taskDataprovider;
  List<BPwidgetTask> tasks;
  BPwidgetJob({
    required this.type,
    required this.id,
    required this.name,
    required this.taskDataprovider,
    required this.tasks,
  });

  @override
  String toString() {
    return 'BPwidgetJob(type: $type, id: $id, name: $name, taskDataprovider: $taskDataprovider, tasks: $tasks)';
  }
}
