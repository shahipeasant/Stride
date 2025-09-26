import 'package:flutter/material.dart';
import 'package:stride/features/logs/view/daily_log_view.dart';
import 'package:stride/features/taught/view/taught_page.dart';
import 'package:stride/features/todo/view/todo_page.dart';

import '../../auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  int _currentIndex = 0;
  final List<Widget> _pages = [
    TaughtPage(),
    TodoPage(),
    DailyLogPage(),
    const Center(child: Text("Events page placeholder")),
  ];
  
  final List<String> _titles = [
    "Taught so far",
    "Today's todo",
    "Daily log",
    "Events"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(onPressed: authService.signOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Taught"),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "Todo"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Events"),
        ],
      ),
    );
  }
}
