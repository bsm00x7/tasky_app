import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/features/home/constant/constant.dart';

import 'package:tasky/models/task_model.dart';
import 'package:tasky/service/preferences.dart';

import '../../core/colors/styles.dart';
import '../../core/enums/taskOptionEnums.dart';
import '../../core/theme/theme_controller.dart';

class Alltaskhighpriority extends StatefulWidget {

  Alltaskhighpriority({super.key });

  @override
  State<Alltaskhighpriority> createState() => _AlltaskhighpriorityState();
}

class _AlltaskhighpriorityState extends State<Alltaskhighpriority> {
  List<TaskModel> task = [];
  List<TaskModel> taskHighPriority = [];
  bool isChechked = false;
  void _onDeleter(String? id)async{
    setState(() {
      taskHighPriority.removeWhere((taskHighPriority) => taskHighPriority.id == id);

    });
    await PreferenceManager().setString(StorgeKey.tasks,jsonEncode( taskHighPriority.map((toElement)=>toElement.toJson()).toList()));


  }
  @override
  void initState() {
    super.initState();
    LoadTaskHight();
  }

  void LoadTaskHight() async {

    final taskString = PreferenceManager().getString(StorgeKey.tasks);
    if (taskString != null) {
      final alldatafterdecoding = jsonDecode(taskString) as List;
      final taskMap = alldatafterdecoding.map((ele) {
        return TaskModel.fromJson(ele);
      }).toList();
      setState(() {
        task = taskMap;
        taskHighPriority = taskMap.where((ele) => ele.taskPriority).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks") , leading: BackButton(
        color: ThemeController().getterThemeMode() == ThemeMode.dark
            ? Color(0xffFFFCFC)
            : Color(0xff161F1B),
      ),),
      body: ListView.separated(
        itemCount: taskHighPriority.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: taskHighPriority[index].isDone,
                    activeColor:AppColor.primryColor,
                    onChanged: (bool? value) async{
                      setState(()    {
                        taskHighPriority[index].isDone = value ?? false;
                        final int newIndex = task.indexWhere((e) =>e.id == taskHighPriority[index].id);
                        task[newIndex] = taskHighPriority[index];

                      });


                      await PreferenceManager().setString(StorgeKey.tasks, jsonEncode(task));


                    },
                  ),
                  SizedBox(width: 8),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            task[index].taskName,
                            maxLines: 1,
                            style: TextStyle(
                              color: task[index].isDone
                                  ? Theme.of(
                                context,
                              ).colorScheme.secondary
                                  : Theme.of(
                                context,
                              ).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: task[index].isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // spacing between title and desc
                          if ( task[index].taskDescription.isNotEmpty)
                            Text(
                              task[index].taskDescription,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      )

                  ),
                  PopupMenuButton<TaskOptionEnum>(
                    iconColor: ThemeController().getterThemeMode() == ThemeMode.dark
                        ? Color(0xFFC6C6C6)
                        : Color(0xFF3A4640),
                    onSelected: (value) {
                      switch(value){
                        case TaskOptionEnum.edit:
                          print(value.name);
                        case TaskOptionEnum.delete:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete  Task"),
                                content: Text("Are Sure Delete This Task  ?"),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("Cancel")),
                                  TextButton(onPressed: (){
                                    _onDeleter(task[index].id);
                                    Navigator.pop(context);
                                  }, child: Text("Delete"))
                                ],
                              );
                            },
                          );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        TaskOptionEnum.values.map((toElement) {
                          return PopupMenuItem <TaskOptionEnum>(
                              value: toElement,
                              child: Text(toElement.name));
                        }).toList(),
                  ),
                ],
              ),
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8,);
      },
      ),
    );
  }
}
