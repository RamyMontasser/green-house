import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';
import 'package:green_house/feature/presentation/cubit/get_outputs_cubit.dart';
import 'package:green_house/feature/presentation/widgets/readings_card.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';


class ChartsScreen extends StatelessWidget {
  ChartsScreen({super.key});

  final ApiService apiService = ApiService();

  final List<SensorModel> sensorData = [];
  //   SensorModel(temp: 2.45, humidity: 32.2, soil: 12, light: 500),
  //   SensorModel(temp: 9.45, humidity: 45.2, soil: 67, light: 300),
  //   SensorModel(temp: 5.45, humidity: 15.2, soil: 98, light: 450),
  //   SensorModel(temp: 1.45, humidity: 28.2, soil: 51, light: 160),
  //   SensorModel(temp: 8.45, humidity: 30.2, soil: 37, light: 700),
  //   SensorModel(temp: 6.45, humidity: 45.2, soil: 28, light: 150),
  // ];

  Color getColor(double value) {
    if (value < 7) return const Color.fromARGB(213, 225, 162, 67);
    if (value > 8) return const Color.fromARGB(255, 113, 246, 255);
    return Colors.green;
  }

  

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => GetOutputsCubit(apiService: apiService)..getSensorsData(),
      child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Analysis",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            letterSpacing: 1.5,
          ),
        ),
        surfaceTintColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: BlocBuilder<GetOutputsCubit, GetOutputsState>(
          builder: (context, state) {
            if (state is GetOutputsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetOutputsSuccess) {
              sensorData.clear();
              sensorData.addAll(state.sensorData);
              return  Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ReadingsCard(
              title: 'Temperature & Humidity',
              diagram: SizedBox(
                height: 100.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),

                    borderData: FlBorderData(show: false),

                    lineBarsData: [
                      LineChartBarData(
                        spots: sensorData.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.temp);
                        }).toList(),
                        isCurved: true,
                        barWidth: 3,
                      ),

                      LineChartBarData(
                        spots: sensorData.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.humidity);
                        }).toList(),
                        isCurved: true,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            ReadingsCard(
              title: "Soil Moisture",
              diagram: SizedBox(
                height: 100.h,
                child: LiquidCircularProgressIndicator(
                  value: ((sensorData.last.soil / 400) * 0.8).clamp(0.0, 0.95),
                  valueColor: AlwaysStoppedAnimation(Color.fromARGB(193, 129, 219, 255)),
                  backgroundColor: Color(0xFF131A2D),
                  borderColor: Color(0xFF3F465C),
                  borderWidth: 2.0,
                  direction: Axis.vertical,
                  center: Text(
                    "${((sensorData.last.soil / 400) * 0.8).clamp(0, 1.0)*100}%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            
            SizedBox(height: 25),

            ReadingsCard(
              title: "LIGHT LEVELS",
              diagram: SizedBox(
                height: 100.h,
                child: BarChart(
                  BarChartData(
                    barGroups: sensorData.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.light.toDouble(),
                            color: getColor(e.value.light.toDouble()),
                            width: 15,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

          ],
        ),
      );
            } else if (state is GetOutputsFailure) {
              return Center(child: Text(state.message));
            }
            return Container();
            })
      
      
     )
    );
  }
}










// SizedBox(
            // height: 50,
            // child:LineChart(
            //       LineChartData(
            //         gridData: FlGridData(show: false),
            //         titlesData: FlTitlesData(show: false),

            //         borderData: FlBorderData(show: false),

            //         lineBarsData: [
            //           LineChartBarData(
            //             spots: sensorData.asMap().entries.map((e) {
            //               return FlSpot(
            //                 e.key.toDouble(),
            //                 e.value.soil.toDouble(),
            //               );
            //             }).toList(),
            //             isCurved: true,
            //             barWidth: 3,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),

            // Stack(
            //                 alignment: Alignment.center,
            //                 children: [
            //                   SizedBox(
            //   height: 100,
            //   child: PieChart(
            //     PieChartData(
            //       startDegreeOffset: 270,

            //       sectionsSpace: 0,
            //       centerSpaceRadius: 40,

            //       sections: [
            //         PieChartSectionData(
            //           value: sensorData[0].soil.toDouble(),
            //           color: getColor(sensorData[0].soil.toDouble()),
            //           radius: 20,
            //           showTitle: false,
            //         ),

            //         PieChartSectionData(
            //           value: 100 - sensorData[0].soil.toDouble(),
            //           color: Colors.grey.shade300,
            //           radius: 20.r,
            //           showTitle: false,
            //         ),
            //       ],
            //     ),
            //   ),
            //                   ),
            //                   Text(
            //   "${sensorData[0].soil.toInt()}%",
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //                   ),
            //                 ],
            //               )








            // ReadingsCard(
            //   title: 'Light',
            //   diagram: SizedBox(
            //     height: 30.h,
            //     child: RotatedBox(
            //       quarterTurns: 1,
            //       child: BarChart(
            //         BarChartData(
            //           maxY: 200,
            //           barGroups: [
            //             BarChartGroupData(
            //               x: 0,
            //               barRods: [
            //                 BarChartRodData(
            //                   toY: sensorData[0].light.toDouble(),
            //                   width: 20,
            //                   backDrawRodData: BackgroundBarChartRodData(
            //                     show: true,
            //                     toY: 200,
            //                     color: Colors.grey.shade300,
            //                   ),
            //                   borderRadius: BorderRadius.circular(8),
            //                   color: getColor(sensorData[0].light.toDouble()),
            //                 ),
            //               ],
            //             ),
            //           ],
            //           titlesData: FlTitlesData(show: false),
            //           gridData: FlGridData(show: false),
            //           borderData: FlBorderData(show: false),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),