import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/colors/styles.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/service/preferences.dart';

import '../../../core/enums/taskOptionEnums.dart';

class SilverTasksWidgets extends StatelessWidget {
  final List<TaskModel> task;

  final Function onTap;
  final Function(String?) onDeleter;
  final Function onEdit ;
  const SilverTasksWidgets({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDeleter, required this.onEdit,

  });
  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: task.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
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
                value: task[index].isDone,
                activeColor: AppColor.primryColor,
                onChanged: (bool? value) {
                  onTap(value, index);
                },
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // left align text
                  children: [
                    Text(
                      task[index].taskName,
                      maxLines: 1,
                      style: TextStyle(
                        color: task[index].isDone
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
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
                    if (task[index].taskDescription.isNotEmpty)
                      Text(
                        task[index].taskDescription,
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFFC6C6C6),
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              PopupMenuButton<TaskOptionEnum>(
                iconColor: ThemeController().getterThemeMode() == ThemeMode.dark
                    ? Color(0xFFC6C6C6)
                    : Color(0xFF3A4640),
                onSelected: (value) async{
                  switch (value) {
                    case TaskOptionEnum.edit:
                   await _showButtomSheet(context, task[index]);
                     onEdit();
                    case TaskOptionEnum.delete:
                     await _buildShowDialog(context, index);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    TaskOptionEnum.values.map((toElement) {
                      return PopupMenuItem<TaskOptionEnum>(
                        value: toElement,
                        child: Text(toElement.name),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 8);
      },
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context, int index) {
    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete  Task"),
                          content: Text("Are Sure Delete This Task  ?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                onDeleter(task[index].id);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
  }

 Future<bool?> _showButtomSheet(BuildContext context, TaskModel uniqueTask) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        GlobalKey<FormState> key = GlobalKey();
        TextEditingController taskName = TextEditingController(
          text: uniqueTask.taskName,
        );
        TextEditingController taskDescription = TextEditingController(
          text: uniqueTask.taskDescription,
        );
        bool isHighPriority = uniqueTask.taskPriority;
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task Name",
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall!.copyWith(fontSize: 16),
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
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall!.copyWith(fontSize: 16),
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
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall!.copyWith(fontSize: 16),
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
                          if (key.currentState?.validate() ?? false) {
                            // Get update Date in Task Model
                            TaskModel updataTask = TaskModel(
                              id: uniqueTask.id,
                              taskName: taskName.value.text,
                              taskDescription: taskDescription.value.text,
                              taskPriority: isHighPriority,
                                isDone : uniqueTask.isDone
                            );
                            final tasks = PreferenceManager().getString("tasks");
                            if (tasks!=null){
                              List <dynamic> taskBeforeUpdate = jsonDecode(tasks);
                              List < TaskModel > taskModeBeforeUpdate = taskBeforeUpdate.map((e)=> TaskModel.fromJson(e)).toList();
                              final int index = taskModeBeforeUpdate.indexWhere((e)=>uniqueTask.id == e.id);

                              taskModeBeforeUpdate[index] =updataTask;

                              final String updatedJsono = jsonEncode(taskModeBeforeUpdate.map((t) => t.toJson()).toList());
                              PreferenceManager().setString("tasks", updatedJsono);
                              Navigator.of(context).pop(true);
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),
                        ),
                        label: Text("EDIT  task"),
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
