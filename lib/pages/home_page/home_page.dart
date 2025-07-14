import 'package:drip/models/task.dart';
import 'package:drip/pages/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Drip",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 70.0,
                                    lineWidth: 25.0,
                                    percent: controller.waterPercentage.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Text(
                                      "% ${(controller.waterPercentage * 100).toStringAsFixed(1)}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    progressColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Column(
                                children: [
                                  const Text(
                                    "Daily Water Goal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      "Your Daily Goal: ${controller.waterGoal.value}",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: controller.incrementWater,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 27.0,
                                      ),
                                      child: const Text(
                                        "Drink Water",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: controller.resetWater,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 47.0,
                                      ),
                                      child: const Text(
                                        "Reset",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: controller.goalController,
                          style: TextStyle(fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            hint: Text(
                              "Update Daily Goal",
                              style: TextStyle(
                                fontWeight: FontWeight.w300
                              ),
                            )
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: controller.updateDailyGoal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [const Text("Update Daily Goal", style: TextStyle(fontWeight: FontWeight.w300),)],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
