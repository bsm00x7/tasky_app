import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasky/core/colors/styles.dart';

class AchievedTasksWidgets extends StatefulWidget {
  final int totalTaskDone;
  final int totalTask;
  final double percentTask;
   AchievedTasksWidgets({super.key , required this.totalTask , required this.totalTaskDone , required this.percentTask});

  @override
  State<AchievedTasksWidgets> createState() => _AchievedTasksWidgetsState();
}

class _AchievedTasksWidgetsState extends State<AchievedTasksWidgets> {
  @override
  Widget build(BuildContext context) {
    return    Container(
      height: 72,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achieved Tasks",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16)
                ),
                Text(
                  "${widget.totalTaskDone} Out of ${widget.totalTask} Done",
                  style: Theme.of(context).textTheme.titleSmall
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "${widget.percentTask.toInt()}%",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14)
                ),
                Transform.rotate(
                  angle: -pi / 2,
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      value: widget.percentTask / 100,
                      backgroundColor:AppColor.primryColor,
                      color:AppColor.primryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
