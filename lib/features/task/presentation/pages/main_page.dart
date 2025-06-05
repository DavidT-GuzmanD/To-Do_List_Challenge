import 'package:flutter/material.dart';
import 'package:todo_list_challenge/features/task/presentation/pages/calendar_page.dart';
import 'package:todo_list_challenge/features/task/presentation/pages/task_list_page.dart';
import 'package:todo_list_challenge/features/task/presentation/pages/today_page.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TaskListPage(),
    const CalendarPage(),
    const TodayPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}