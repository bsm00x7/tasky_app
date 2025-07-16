import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../../models/task_model.dart';
import '../../../service/preferences.dart';

class HomeController with ChangeNotifier{

  String? username;
  List<TaskModel> task = [];
  int totalTaskDone = 0;
  int totalTask = 0;
  double percentTask = 0;
  List<TaskModel> taskHighPriority = [];
  String? user_image;
  void init() {
    loadUserName();
    loadTaskData();
  }
  HomeController(){
    init();
  }










  void loadUserName() async {

      username = PreferenceManager().getString("username");
      user_image  = PreferenceManager().getString("user_image");
    notifyListeners();
  }

  void loadTaskData() async {
    final data = PreferenceManager().getString("tasks");
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      final tasks = decoded.map((e) => TaskModel.fromJson(e)).toList();
        task = tasks;
        calculateLogicTasks();
        calculateHighPriorityTask();

    }


    notifyListeners();
  }


  void calculateHighPriorityTask() {
    taskHighPriority = task.where((ele) => ele.taskPriority).toList();
  }
  void onDeleter(String? id)async{

      task.removeWhere((task) => task.id == id);
      calculateLogicTasks();
    await PreferenceManager().setString("tasks",jsonEncode( task.map((toElement)=>toElement.toJson()).toList()));
      notifyListeners();


  }
  void calculateLogicTasks() {
    totalTask = task.length;
    totalTaskDone = task.where((ele) => ele.isDone).length;
    percentTask = ((totalTask == 0 ? 0 : totalTaskDone / totalTask) * 100);
    notifyListeners();
  }

  void ChangeStateCheckBoxHigthPriorty(int index , bool? value){

      taskHighPriority[index]
          .isDone =
          value ?? false;
      var mainIndex = task.indexWhere(
            (t) =>
        t.id ==
            taskHighPriority[index]
                .id,
      );
      if (mainIndex != -1) {
        task[mainIndex].isDone =
            value ?? false;
      }
      calculateLogicTasks();

    final updatedTask = task
        .map((e) => e.toJson())
        .toList();
    PreferenceManager().setString(
      "tasks",
      jsonEncode(updatedTask),
    );
      notifyListeners();
  }
  void ChangeStateCheckBox( { required int index , required bool? value}){

      task[index].isDone = value ?? false;
      calculateLogicTasks();

    final updatedTask = task.map((e) => e.toJson()).toList();
    PreferenceManager().setString(
      "tasks",
      jsonEncode(updatedTask),
    );
      notifyListeners();
  }

}