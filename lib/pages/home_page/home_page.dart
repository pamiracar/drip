import 'package:drip/app_routes.dart';
import 'package:drip/pages/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Drip - Your Water Tracker",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed:() => Get.toNamed(AppRoutes.PROFILE), icon: Icon(Icons.bar_chart_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                _StreakCard(controller: controller),
                SizedBox(height: 5),
                _DailyGoalCard(controller: controller),
                SizedBox(height: 40),
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
      ),
    );
  }
}

class _DailyGoalCard extends StatefulWidget {
  const _DailyGoalCard({required this.controller});

  final HomePageController controller;

  @override
  State<_DailyGoalCard> createState() => _DailyGoalCardState();
}

class _DailyGoalCardState extends State<_DailyGoalCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                          animation: true,
                          animationDuration: 1000,
                          animateFromLastPercent: true,
                          percent: widget.controller.waterPercentage.clamp(
                            0.0,
                            1.0,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "${widget.controller.waterDrank.value} mL",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Daily Goal: ${widget.controller.waterGoal.value} mL",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed:() => widget.controller.drinkWater(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                child: const Text(
                                  "Drink Water",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed: widget.controller.resetWater,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                child: const Text(
                                  "Reset",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: widget.controller.goalController,
                style: TextStyle(fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  hint: Text(
                    "Update Daily Goal (mL)",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: widget.controller.updateDailyGoal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Update Daily Goal",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakCard extends StatefulWidget {
  const _StreakCard({required this.controller});

  final HomePageController controller;

  @override
  State<_StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<_StreakCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                animation: true,
                animationDuration: 1000,
                lineWidth: 20.0,
                percent: widget.controller.streakPercentage.clamp(0.0, 1.0),
                circularStrokeCap: CircularStrokeCap.round,
                center: Lottie.asset(
                  "assets/animations/streak.json",
                  width: 40,
                ),

                progressColor: Colors.deepOrange,
              ),

              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Water Streak",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      """Achieve your goals for 10 day""",
                      style: TextStyle(color: Colors.deepOrange),
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Day: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "${widget.controller.streakDay.value}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 30,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
