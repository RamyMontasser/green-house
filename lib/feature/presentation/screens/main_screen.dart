import 'package:flutter/material.dart';
import 'package:green_house/core/widgets/custom_bottom_nav_bar.dart';
import 'package:green_house/feature/presentation/screens/charts_screen.dart';
import 'package:green_house/feature/presentation/screens/control_screen.dart';
import 'package:green_house/feature/presentation/screens/home_screen.dart';
import 'package:green_house/feature/presentation/screens/model_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    HomeScreen(),
    ChartsScreen(),
    ControlScreen(),
    ModelScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (int index) => _onItemTapped(index),
      ),
    );
  }
}
