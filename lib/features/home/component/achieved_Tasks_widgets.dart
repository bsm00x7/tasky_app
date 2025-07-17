import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/colors/styles.dart';
import 'package:tasky/features/home/controller/home_controller.dart';

class AchievedTasksWidgets extends StatelessWidget {

   AchievedTasksWidgets({super.key });

  @override
  Widget build(BuildContext context) {
    return   Consumer<HomeController>(
      builder: (BuildContext context,HomeController value, Widget? child) {
        return Container(
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
                        "${value.totalTaskDone} Out of ${value.totalTask} Done",
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
                        "${value.percentTask.toInt()}%",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14)
                    ),
                    Transform.rotate(
                      angle: -pi / 2,
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: CircularProgressIndicator(
                          value: value.percentTask / 100,
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


      },

    );
  }
}
