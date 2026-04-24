import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/core/service/signalr_service.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';
import 'package:green_house/feature/data/models/sensor_status.dart';
import 'package:green_house/feature/presentation/widgets/sensor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  // final List<SensorModel> sensorData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


    
  late SignalRService signalRService;

  @override
  void initState() {
    super.initState();

    signalRService = SignalRService();

    // signalRService.onDataReceived = (data) {
    //   setState(() {
    //     widget.sensorData.add(SensorModel.fromJson(data));
    //   });
    // };

    signalRService.init();
  }


  @override
  void dispose() {
    signalRService.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            letterSpacing: 1.5,
          ),
        ),
                surfaceTintColor: Color.fromARGB(255, 0, 0, 0),

      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: signalRService.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          final sensor = SensorModel.fromJson(data);

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SensorCard(
                  //   title: 'Temperature', 
                  //   value: sensor.temp, 
                  //   maxValue: maxValue, 
                  //   unit: unit)
                  SensorCard(
                    title: 'Temperature', 
                    value: sensor.temp, 
                    status: getTempStatus(sensor.temp),
                  ),
                  SizedBox(height: 5.h,),
                  SensorCard(
                    title: 'Humidity', 
                    value: sensor.humidity, 
                    status: getHumidityStatus(sensor.humidity),
                  ),
                  SizedBox(height: 5.h),
                  SensorCard(
                    title: 'Soil', 
                    value: sensor.soil.toDouble(), 
                    status: getSoilStatus(sensor.soil.toDouble()),
                  ),
                  SizedBox(height: 5.h),
                  SensorCard(
                    title: 'Light', 
                    value: sensor.light.toDouble(), 
                    status: getLightStatus(sensor.light.toDouble()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
}

SensorStatus getTempStatus(double value) {
    if (value < 35) {
      return SensorStatus("Increase ❄️", const Color.fromARGB(255, 121, 190, 246), Icons.arrow_upward);
    } else if (value > 35) {
      return SensorStatus("Decrease 🔥", Colors.red, Icons.arrow_downward);
    } else {
      return SensorStatus("Perfect ✅", Colors.green, Icons.check);
    }
  }

SensorStatus getHumidityStatus(double value) {
    if (value < 70) {
      return SensorStatus("Increase 💧", const Color.fromARGB(255, 148, 89, 1), Icons.arrow_upward);
    } else if (value > 70) {
      return SensorStatus("Decrease 🌬", Colors.orange, Icons.arrow_downward);
    } else {
      return SensorStatus("Perfect ✅", Colors.green, Icons.check);
    }
  }

  SensorStatus getSoilStatus(double value) {
    if (value < 400) {
      return SensorStatus("Needs Water 💧", const Color.fromARGB(220, 169, 102, 1), Icons.water_drop);
    } else if (value > 400) {
      return SensorStatus("Too Wet 🌧", Colors.blue, Icons.warning);
    } else {
      return SensorStatus("Perfect 🌱", Colors.green, Icons.check);
    }
  }

  SensorStatus getLightStatus(double value) {
    if (value < 300) {
      return SensorStatus("Need Light ☀️", const Color.fromARGB(215, 255, 183, 76), Icons.wb_sunny);
    } else if (value > 300) {
      return SensorStatus("Too Bright 🌞", Colors.red, Icons.highlight);
    } else {
      return SensorStatus("Perfect 🌤", Colors.green, Icons.check);
    }
  }


}