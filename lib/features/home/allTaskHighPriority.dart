import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/controller/home_controller.dart';
import 'package:tasky/models/task_model.dart';
import '../../core/colors/styles.dart';
import '../../core/enums/taskOptionEnums.dart';
import '../../core/theme/theme_controller.dart';
import '../../service/preferences.dart';

class Alltaskhighpriority extends StatelessWidget {
  const Alltaskhighpriority({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController.Hight(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("High Priority Tasks"),
          leading: BackButton(
            color: ThemeController().getterThemeMode() == ThemeMode.dark
                ? const Color(0xffFFFCFC)
                : const Color(0xff161F1B),
          ),
        ),
        body: Consumer<HomeController>(
          builder: (context, controller, _) {
            final tasks = controller.taskHighPriority;
            return ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = tasks[index];
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
                        const SizedBox(width: 4),
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: task.isDone,
                          activeColor: AppColor.primryColor,
                          onChanged: (value) {
                            controller.changeStateCheckBoxHigthPriorty(
                              index: index,
                              value: value,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task.taskName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: task.isDone
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (task.taskDescription.isNotEmpty)
                                Text(
                                  task.taskDescription,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        PopupMenuButton<TaskOptionEnum>(
                          iconColor: ThemeController().getterThemeMode() == ThemeMode.dark
                              ? const Color(0xFFC6C6C6)
                              : const Color(0xFF3A4640),
                          onSelected: (valueEnum)async {
                            switch (valueEnum) {
                              case TaskOptionEnum.edit:
                                final updated = await _showButtomSheet(context, task);
                                if (updated == true) {
                                  controller.loadTaskData(); // or controller.initHightTask();
                                }

                                break;
                              case TaskOptionEnum.delete:
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Task"),
                                      content: const Text("Are you sure you want to delete this task?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.onDeleter(task.id);
                                            Navigator.pop(context);
                                            controller.initHightTask();
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return TaskOptionEnum.values.map((toElement) {
                              return PopupMenuItem<TaskOptionEnum>(
                                value: toElement,
                                child: Text(toElement.name),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
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
