import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/service/preferences.dart';

import '../../widgets/tasks_widgets.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  void initState() {
    _loadTaskDate();
    super.initState();
  }

  List<TaskModel> tasksIsNotDone = [];
  void _onDeleter(String? id)async{


    setState(() {
      tasksIsNotDone.removeWhere((task) => task.id == id);

    });
    await PreferenceManager().setString("tasks",jsonEncode( tasksIsNotDone.map((toElement)=>toElement.toJson()).toList()));


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Completed Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TasksWidgets(
          task: tasksIsNotDone,
          onTap: (bool? value, int index) async {
            setState(() {
              tasksIsNotDone[index].isDone = value ?? false;
            });



            final allTaskDate = PreferenceManager().getString('tasks');
            if (allTaskDate != null) {
              final List<TaskModel> allDatelis =
                  (jsonDecode(allTaskDate) as List)
                      .map((ele) => TaskModel.fromJson(ele))
                      .toList();
              final newIndex = allDatelis.indexWhere(
                (e) => e.id == tasksIsNotDone[index].id,
              );
              allDatelis[newIndex] = tasksIsNotDone[index];
              PreferenceManager().setString("tasks", jsonEncode(allDatelis));
              _loadTaskDate();
            }

          }, onDeleter: (String id ) {_onDeleter(id) ; }, onEdit: ()=>_loadTaskDate(),
        ),
      ),
    );
  }

  void _loadTaskDate() async {

    final finalist = PreferenceManager().getString("tasks");

    if (finalist != null) {
      final taskAfterDecCode = jsonDecode(finalist) as List<dynamic>;

      setState(() {
        final taskMap = taskAfterDecCode.map((toElement) {
          return TaskModel.fromJson(toElement);
        }).toList();
        tasksIsNotDone = taskMap;
        tasksIsNotDone = tasksIsNotDone
            .where((ele) => !ele.isDone == false)
            .toList();
      });
    }
  }
}
