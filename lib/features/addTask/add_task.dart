import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/features/addTask/controller/add_task_controller.dart';

import '../../core/colors/styles.dart';



class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AddTaskController(),
      builder: (context, _) {
        final controller = context.read<AddTaskController>();
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: ThemeController().getterThemeMode() == ThemeMode.dark
                  ? Color(0xffFFFCFC)
                  : Color(0xff161F1B),
            ),
            title: Text("New Task"),
            iconTheme: IconThemeData(color: AppColor.textColor),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: controller.key,
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

                    controller: controller.taskName,
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
                    controller: controller.taskDescription,
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
                      Consumer<AddTaskController>(
                        builder: (BuildContext context, value, Widget? child) {
                          return Switch(
                            value: value.isHighPriority,
                            onChanged: (value) {
                              controller.toggled(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        controller.addTask(context);
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
      },
    );
  }
}
