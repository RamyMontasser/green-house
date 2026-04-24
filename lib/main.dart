import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/feature/presentation/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.03),
            ),
          ),
          child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green House',
      theme: ThemeData.dark(useMaterial3: true),
      // ThemeData(
      //   scaffoldBackgroundColor: Color(0xFF0F172A)
      // ),
      
      // themeMode: ThemeMode.dark,
      // darkTheme: ThemeData(
      //   scaffoldBackgroundColor: Color(0xFF0F172A)
      // ),
      home: const MainScreen(),
    )
    );
    }
    );
  }
}


