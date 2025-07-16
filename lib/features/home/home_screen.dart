import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/features/home/add_task.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/service/preferences.dart';

import 'component/achieved_Tasks_widgets.dart';
import 'component/silver_tasks_widgets.dart';
import 'allTaskHighPriority.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  List<TaskModel> task = [];
  int totalTaskDone = 0;
  int totalTask = 0;
  double percentTask = 0;
  List<TaskModel> taskHighPriority = [];
  String? user_image;

  @override
  void initState() {
    _loadUserName();
    _loadTaskData();
    super.initState();
  }

  void _calculateHighPriorityTask() {
    taskHighPriority = task.where((ele) => ele.taskPriority).toList();
  }
void _onDeleter(String? id)async{
  setState(() {
    task.removeWhere((task) => task.id == id);
    _calculateLogicTasks();
  });
  await PreferenceManager().setString("tasks",jsonEncode( task.map((toElement)=>toElement.toJson()).toList()));


}
  void _calculateLogicTasks() {
    totalTask = task.length;
    totalTaskDone = task.where((ele) => ele.isDone).length;
    percentTask = ((totalTask == 0 ? 0 : totalTaskDone / totalTask) * 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 170,
        height: 45,
        child: FloatingActionButton(
          tooltip: "Add New Task",
          child: Text("Add New Task"),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddTask()),
            );
            _loadTaskData();
            _calculateHighPriorityTask();
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user_image != null
                          ? CircleAvatar(backgroundImage: FileImage(File(user_image!)))
                          : CircleAvatar(child: SvgPicture.asset("assets/images/Leading element.svg", width: 30, height: 30)),

                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening, $username",
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium!.copyWith(fontSize: 16),
                          ),
                          Text(
                            "One task at a time. One step \ncloser.",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Header Message
                  Text(
                    "Yuhuu, Your work Is",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done!",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SvgPicture.asset(
                        "assets/images/waving-hand-medium-light-skin-tone-svgrepo-com 1.svg",
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Achieved Tasks
                  AchievedTasksWidgets(
                    totalTask: totalTask,
                    totalTaskDone: totalTaskDone,
                    percentTask: percentTask,
                  ),

                  const SizedBox(height: 8),

                  // High Priority Tasks Section
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 176,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "High Priority Tasks",
                                style: TextStyle(
                                  color: Color(0xFF15B86C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (taskHighPriority.isNotEmpty)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: min(4, taskHighPriority.length),
                                    itemBuilder: (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 32,
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              activeColor: Color(0xFF15B86C),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              value: taskHighPriority[index]
                                                  .isDone,
                                              onChanged: (value) async {
                                                setState(() {
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
                                                  _calculateLogicTasks();
                                                });

                                                final updatedTask = task
                                                    .map((e) => e.toJson())
                                                    .toList();
                                                PreferenceManager().setString(
                                                  "tasks",
                                                  jsonEncode(updatedTask),
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                taskHighPriority[index]
                                                    .taskName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color:
                                                      taskHighPriority[index]
                                                          .isDone
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.secondary
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      taskHighPriority[index]
                                                          .isDone
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40, right: 15),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Alltaskhighpriority(),
                              ),
                            );
                            _loadTaskData();
                            _calculateLogicTasks();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                width: 1.5,
                                color: Color(0xFF6E6E6E),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/images/higthsvg.svg",
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "My Tasks",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16)),
            // ✅ Main Sliver Task List (outside Column)
            SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
              sliver: SilverTasksWidgets(
                task: task,
                onTap: (bool? value, int index) async {
                  setState(() {
                    task[index].isDone = value ?? false;
                    _calculateLogicTasks();
                  });

                  final updatedTask = task.map((e) => e.toJson()).toList();
                  PreferenceManager().setString(
                    "tasks",
                    jsonEncode(updatedTask),
                  );
                },
                onDeleter: (String? id)  {
                  _onDeleter(id);


                }, onEdit: ()=> _loadTaskData(),
              ),
            ),

            // ✅ Add New Task Button (also inside Sliver)
          ],
        ),
      ),
    );
  }

  void _loadUserName() async {
    setState(() {
      username = PreferenceManager().getString("username");
      user_image  = PreferenceManager().getString("user_image");
    });
  }

  void _loadTaskData() async {
    final data = PreferenceManager().getString("tasks");
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      final tasks = decoded.map((e) => TaskModel.fromJson(e)).toList();
      setState(() {
        task = tasks;
        _calculateLogicTasks();
        _calculateHighPriorityTask();
      });
    }
  }
}
