
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/todo/todo_controller.dart';

import '../../widgets/tasks_widgets.dart';

class todoscreen extends StatefulWidget {

   const todoscreen({super.key });


  @override
  State<todoscreen> createState() => todoscreenState();
}

class todoscreenState extends State<todoscreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>ToDoController(),
      child: Scaffold(
        appBar: AppBar(title:  Text("To Do Tasks"),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ToDoController>(
            builder: (BuildContext context, ToDoController controller, Widget? child) {
              return TasksWidgets(
                task:controller.tasksIsNotDone,
                onTap: (bool? value,int index )async{
                  controller.onTap(index: index, value: value);
                }, onDeleter: (String id ) { controller.onDeleter(id); }, onEdit: ()=>controller.loadTaskDate(),);
            },
          ),
        ),
      ),
    );
  }

}
