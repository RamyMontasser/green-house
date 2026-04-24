import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/feature/data/models/sensor_status.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final double value;
  // final Widget chart;
  final SensorStatus status;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    // required this.chart, 
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text('$value', style: TextStyle(fontSize: 24.sp)),
            SizedBox(height: 8.h),
            Text(status.text, style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 12.h),
            AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 12.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: status.color,
      ),
      child: FractionallySizedBox(
    alignment: Alignment.centerLeft,
    // widthFactor: value, 
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: status.color,
      ),
    ),
  ),
    ),
            
          ],
        ),
      ),
    );
  }
}
