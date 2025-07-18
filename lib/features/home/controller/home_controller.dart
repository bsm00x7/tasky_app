import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tasky/features/home/constant/constant.dart';

import '../../../models/task_model.dart';
import '../../../service/preferences.dart';

class HomeController with ChangeNotifier{

  String? username;
  List<TaskModel> task = [];
  int totalTaskDone = 0;
  int totalTask = 0;
  double percentTask = 0;
  List<TaskModel> taskHighPriority = [];
  bool isChechked = false;
  String? user_image;
  String? motivation ;
  void init() {
    loadUserData();
    loadTaskData();
  }
  void initHightTask() {
    LoadTaskHight();
  }
  HomeController.Hight(){
    initHightTask();
  }
  HomeController(){
    init();
  }
  void loadUserData() async {
      username = PreferenceManager().getString(StorgeKey.username);
      user_image  = PreferenceManager().getString(StorgeKey.user_image);
      motivation = PreferenceManager().getString(StorgeKey.motivation);
    notifyListeners();
  }
  void loadTaskData() async {
    final data = PreferenceManager().getString(StorgeKey.tasks);
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
    await PreferenceManager().setString(StorgeKey.tasks,jsonEncode( task.map((toElement)=>toElement.toJson()).toList()));
      notifyListeners();


  }
  void calculateLogicTasks() {
    totalTask = task.length;
    totalTaskDone = task.where((ele) => ele.isDone).length;
    percentTask = ((totalTask == 0 ? 0 : totalTaskDone / totalTask) * 100);
    notifyListeners();
  }

  void changeStateCheckBoxHigthPriorty({ required int index , required bool? value}){

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
      StorgeKey.tasks,
      jsonEncode(updatedTask),
    );
      notifyListeners();
  }
  void changeStateCheckBox( { required int index , required bool? value}){

      task[index].isDone = value ?? false;
      calculateLogicTasks();

    final updatedTask = task.map((e) => e.toJson()).toList();
    PreferenceManager().setString(
      StorgeKey.tasks,
      jsonEncode(updatedTask),
    );
      notifyListeners();
  }
  void LoadTaskHight() async {

    final taskString = PreferenceManager().getString(StorgeKey.tasks);
    if (taskString != null) {
      final alldatafterdecoding = jsonDecode(taskString) as List;
      final taskMap = alldatafterdecoding.map((ele) {
        return TaskModel.fromJson(ele);
      }).toList();

        task = taskMap;
        taskHighPriority = taskMap.where((ele) => ele.taskPriority).toList();
    }
  }
}