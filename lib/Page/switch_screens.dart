import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/features/profile/profile_screen.dart';
import 'package:tasky/features/todo/todoscreen.dart';

import '../core/colors/styles.dart';
import '../features/completed/completed_screen.dart';
import '../features/home/home_screen.dart';

class SiwtchScreen extends StatefulWidget {
  const SiwtchScreen({super.key});

  @override
  State<SiwtchScreen> createState() => _SiwtchScreenState();
}

class _SiwtchScreenState extends State<SiwtchScreen> {
  int _currentIndex = 0;
  final List<dynamic> _page = [

    HomeScreen(),
    todoscreen(),
    CompletedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color(0xFFC6C6C6),
        selectedItemColor: AppColor.primryColor,
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/Hom.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ?AppColor.primryColor : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/todo.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ?AppColor.primryColor : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),

            label: "To Do",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/completed_task.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ?AppColor.primryColor : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/profile.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? AppColor.primryColor : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
      body:SafeArea(child:  _page[_currentIndex]),
    );
  }
}
