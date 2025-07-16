import 'dart:convert';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/features/home/constant/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';


import '../../core/colors/styles.dart';
import '../../models/task_model.dart';
import '../../service/preferences.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskName = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  bool isHighPriority = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
       leading: BackButton(
         color:ThemeController().getterThemeMode()==ThemeMode.dark ?Color(0xffFFFCFC) : Color(0xff161F1B),
       ),

        title: Text("New Task"),
        iconTheme: IconThemeData(color:AppColor.textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Name",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),

              TextFormField(

                validator: (String? value) {
                  if (value?.trim().isEmpty ?? false) {
                    return "Please Enter Task Name";
                  }
                  return null;
                },

                controller: taskName,
                decoration: InputDecoration(
                  hintText: "Finish UI design for login screen",

                ),
              ),
              SizedBox(height: 20),
              Text(
                "Task Description",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(


                controller: taskDescription,
                maxLines: 5,

                decoration: InputDecoration(
                  hintText:
                      "Finish onboarding UI and hand off to devs by Thursday.",

                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "High Priority",
                    style:Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
                  ),
                  Switch(
                    value: isHighPriority,
                    onChanged: (value) {
                      setState(() {
                        isHighPriority = value;
                      });
                    },

                  ),
                ],
              ),
              Spacer(),

              /// BOTTM ADD TASK
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
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
                  },

                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  label: Text("Add  task"),
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
