import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final Function(int) onTap;

  final List<Map<String, dynamic>> _items = [
    {"icon": Icons.dashboard, "label": "DASHBOARD"},
    {"icon": Icons.data_exploration, "label": "DATA ANALYSIS"},
    {"icon": Icons.tune, "label": "CONTROL"},
    {"icon": Icons.psychology, "label": "AI ANALYSIS"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(0xFF03DAC6).withValues(alpha: 0.4),
                              blurRadius: 15.r,
                              spreadRadius: 5.r,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _items[index]["icon"],
                    color: isSelected ? Color(0xFF00E5FF) : Colors.white60,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _items[index]["label"],
                  style: TextStyle(
                    color: isSelected ? Colors.cyanAccent : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
