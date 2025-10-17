/*
@author     : karthick.d  23/09/2025
@desc       : split screen divides the scree in to two section where one part 
              is for widgets for draggable  and another for dragtarget canvas
              
              need two instance fields for no of columns 
              and no of 

*/

import 'package:dashboard/bloc/bpwidgetaction/bloc/bpwidget_action_bloc.dart';
import 'package:dashboard/bloc/bpwidgetprops/bpwidget_props_bloc.dart';
import 'package:dashboard/bloc/bpwidgets/bpwidget_bloc.dart';
import 'package:dashboard/widgets/split_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});
  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BpwidgetPropsBloc(), lazy: false),
        BlocProvider(create: (context) => BpwidgetBloc(), lazy: false),
        BlocProvider(create: (context) => BpwidgetActionBloc(), lazy: false),
      ],
      child: Scaffold(body: SplitPanel()),
    );
  }
}
