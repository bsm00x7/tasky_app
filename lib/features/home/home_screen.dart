import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/addTask/add_task.dart';

import 'allTaskHighPriority.dart';
import 'component/achieved_Tasks_widgets.dart';
import 'component/silver_tasks_widgets.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return HomeController();
      },
      child: Consumer<HomeController>(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final controller = context.read<HomeController>();
          return Scaffold(
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
                            value.user_image != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(value.user_image!),
                                    ),
                                  )
                                : CircleAvatar(
                                    child: SvgPicture.asset(
                                      "assets/images/Leading element.svg",
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),

                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Selector<HomeController, String?>(
                                  selector:
                                      (BuildContext, HomeController username) =>
                                          username.username,
                                  builder:
                                      (
                                        BuildContext context,
                                        String? username,
                                        Widget? child,
                                      ) => Text(
                                        "Good Evening, $username",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(fontSize: 16),
                                      ),
                                ),
                                Selector<HomeController, String?>(
                                  selector: (BuildContext, Controller) =>
                                      Controller.motivation,
                                  builder:
                                      (
                                        BuildContext context,
                                        String? motivation,
                                        Widget? child,
                                      ) => Text(
                                        motivation ??
                                            "One task at a time. One step \ncloser.",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      ),
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

                        // fixed Archived Task Widgets with add consumer in ArchivedTaskWidgets.dart and convert StateFullWidget for StateLessWidgets
                        // And Deleter all send Parameter and hold data in HomeController
                        AchievedTasksWidgets(),

                        const SizedBox(height: 8),

                        // High Priority Tasks Section
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 176,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
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
                                    if (value.taskHighPriority.isNotEmpty)
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: min(
                                            4,
                                            value.taskHighPriority.length,
                                          ),
                                          itemBuilder: (BuildContext context, int index) {
                                            return SizedBox(
                                              height: 32,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor: Color(
                                                      0xFF15B86C,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    value: value
                                                        .taskHighPriority[index]
                                                        .isDone,
                                                    onChanged: (value) {
                                                      controller
                                                          .changeStateCheckBoxHigthPriorty(
                                                            index: index,
                                                            value: value,
                                                          );
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      value
                                                          .taskHighPriority[index]
                                                          .taskName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            value
                                                                .taskHighPriority[index]
                                                                .isDone
                                                            ? Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary
                                                            : Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        decoration:
                                                            value
                                                                .taskHighPriority[index]
                                                                .isDone
                                                            ? TextDecoration
                                                                  .lineThrough
                                                            : TextDecoration
                                                                  .none,
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
                              padding: const EdgeInsets.only(
                                bottom: 40,
                                right: 15,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Alltaskhighpriority(),
                                    ),
                                  );
                                  controller.loadTaskData();
                                  controller.calculateLogicTasks();
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
                      task: value.task,
                      onTap: (bool? value, int index) {
                        controller.changeStateCheckBox(
                          index: index,
                          value: value,
                        );
                      },
                      onDeleter: (String? id) {
                        controller.onDeleter(id);
                      },
                      onEdit: () => controller.loadTaskData(),
                    ),
                  ),

                  // ✅ Add New Task Button (also inside Sliver)
                ],
              ),
            ),
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
                  controller.loadTaskData();
                  controller.calculateHighPriorityTask();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
