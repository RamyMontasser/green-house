import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:green_house/feature/presentation/manager/config_cubit/config_cubit.dart';
import 'package:green_house/feature/presentation/widgets/auto_control_switch.dart';
import 'package:green_house/feature/presentation/widgets/config_form.dart';
import 'package:green_house/feature/presentation/widgets/device_switch.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigCubit(ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Control Devices",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              letterSpacing: 1.5,
            ),
          ),
          surfaceTintColor: Color.fromARGB(255, 0, 0, 0),
        ),
        body: ListView(
          children: [
            SizedBox(height: 30.h),
            DeviceSwitch(
              title: "Ventilation Fan",
              icon: Icons.wind_power,
              onEndpoint: "fan/on",
              offEndpoint: "fan/off",
            ),
            SizedBox(height: 10.h),
            DeviceSwitch(
              title: "LED Lighting",
              icon: Icons.lightbulb,
              onEndpoint: "led/on",
              offEndpoint: "led/off",
            ),
            SizedBox(height: 10.h),
            DeviceSwitch(
              title: "Irrigation Pump",
              icon: Icons.water_drop,
              onEndpoint: "pump/on",
              offEndpoint: "pump/off",
            ),
            Divider(color: Colors.white24),
            AutoControlSwitch(),
            Divider(color: Colors.white24),
            ConfigForm(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}