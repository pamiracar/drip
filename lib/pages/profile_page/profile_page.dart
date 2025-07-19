import 'package:drip/pages/profile_page/profile_page_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Your Water Stats",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Obx(() {
                  final hasData = controller.waterData.isNotEmpty;
                  final spots = hasData
                      ? controller.waterData
                      : List.generate(7, (i) => FlSpot(i.toDouble(), 0));
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.bar_chart_rounded),
                            Chip(label: const Text("Water Stats", style: TextStyle(fontSize: 12),)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              lineTouchData: LineTouchData(enabled: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  curveSmoothness: 0.1,
                                  isCurved: true,
                                  barWidth: 3,
                                  color: Theme.of(context).primaryColor,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                ),
                              ],

                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      final days = [
                                        '7 days',
                                        '6 days',
                                        "5 days",
                                        "4 days",
                                        "3 days",
                                        "Yesterday",
                                        "Today",
                                      ];
                                      return Column(
                                        children: [
                                          SizedBox(height: 10,),
                                          Text(
                                            days[index],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),

                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 100.h),
              Text(
                '"${controller.randomQuote?["quote"]}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                "~ ${controller.randomQuote?["author"]}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
