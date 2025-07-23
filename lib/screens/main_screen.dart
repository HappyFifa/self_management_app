import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'todo_screen.dart';
import 'calendar_screen.dart';
import 'reflection_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TodoScreen(),
    CalendarScreen(),
    ReflectionScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.listCheck), label: 'Tugas'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendarDays), label: 'Kalender'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookOpen), label: 'Refleksi'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
