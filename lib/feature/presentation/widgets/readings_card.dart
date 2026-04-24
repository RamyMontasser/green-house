import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReadingsCard extends StatelessWidget {
  final String title;
  final Widget diagram;
  final bool isActive;

  const ReadingsCard({
    super.key,
    required this.title,
    required this.diagram,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 1, 1), 
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 5.r,
            spreadRadius: 1.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  letterSpacing: 1.5,
                ),
              ),
              if (isActive)
                Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.tealAccent, 
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 10.h),
          
          SizedBox(height: 20.h),
          diagram, 
        ],
      ),
    );
  }
}
