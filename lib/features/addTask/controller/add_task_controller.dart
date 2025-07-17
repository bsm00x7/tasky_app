import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/task_model.dart';
import '../../../service/preferences.dart';
import '../../home/constant/constant.dart';

class AddTaskController with ChangeNotifier{
  final TextEditingController taskName = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey();
  bool isHighPriority = false;

  void addTask(BuildContext context)async {
    if (key.currentState?.validate() ?? false) {
      // load Task Date in Map < String , dynamic> [dynamic because in time string and anthor time boolean]
      var uuid = Uuid();
      String uniqueId = uuid.v4();
      TaskModel model = TaskModel(

        id: uniqueId,
        taskName: taskName.value.text,
        taskDescription: taskDescription.value.text,
        taskPriority: isHighPriority,
        isDone: false,
      );

      // Create Instance of SharedPreferences

      // Load Task Date in List after EnCoder with Json

      final taskjson =   PreferenceManager().getString(StorgeKey.tasks);
      List<dynamic> listTasks = [];
      if (taskjson != null) {
        listTasks = jsonDecode(taskjson);
      }
      listTasks.add(model.toJson());
      await PreferenceManager().setString(StorgeKey.tasks, jsonEncode(listTasks));

      Navigator.pop(context);
    }
    notifyListeners();
  }
  void toggled(bool value){
    isHighPriority = value;
    notifyListeners();
  }


}