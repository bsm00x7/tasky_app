import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../models/task_model.dart';
import '../../service/preferences.dart';
import '../home/constant/constant.dart';

class ToDoController with ChangeNotifier{

  void init() {
    loadTaskDate();
  }
  ToDoController(){
    init();

  }
  List <TaskModel> tasksIsNotDone=[];





// load Task Date
  void loadTaskDate() async {
    final finalist = PreferenceManager().getString(StorgeKey.tasks);
    if (finalist != null) {
      final taskAfterDecCode = jsonDecode(finalist) as List<dynamic>;
        final taskMap = taskAfterDecCode.map((toElement) {
          return  TaskModel.fromJson(toElement);
        }).toList();
        tasksIsNotDone = taskMap;
        tasksIsNotDone = tasksIsNotDone.where((ele)=> ele.isDone==false).toList();

    }
    notifyListeners();
  }



  // Deleter Task  is Defernent beetwin deleter in Home_controller
  void onDeleter(String? id)async{

      tasksIsNotDone.removeWhere((task) => task.id == id);

    await PreferenceManager().setString(StorgeKey.tasks,jsonEncode( tasksIsNotDone.map((toElement)=>toElement.toJson()).toList()));
  notifyListeners();
  }
// on tap


void onTap({ required int index , required bool? value}){
    tasksIsNotDone[index].isDone = value ?? false;
  final allTaskDate = PreferenceManager().getString(StorgeKey.tasks);
  if (allTaskDate != null) {
    final List<TaskModel> allDatelis =
    (jsonDecode(allTaskDate) as List)
        .map((ele) => TaskModel.fromJson(ele))
        .toList();
    final newIndex = allDatelis.indexWhere(
          (e) => e.id == tasksIsNotDone[index].id,
    );
    allDatelis[newIndex] = tasksIsNotDone[index];
    PreferenceManager().setString(StorgeKey.tasks, jsonEncode(allDatelis));
    loadTaskDate();
  }
}


}