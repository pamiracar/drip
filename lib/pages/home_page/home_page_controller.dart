// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:drip/models/drip.dart';
import 'package:drip/models/water.dart';
import 'package:drip/quotes.dart';
import 'package:drip/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxInt waterGoal = 2500.obs;
  RxInt waterDrank = 0.obs;
  TextEditingController goalController = TextEditingController();
  TextEditingController waterValueController = TextEditingController(text: "0");
  final DatabaseService databaseService = DatabaseService.instance;
  RxInt streakDay = 0.obs;
  RxInt streakGoal = 10.obs;
  RxInt selectedWaterML = 200.obs;
  Map<String, String>? randomQuote;
  RxInt waterValue = 0.obs;

  double get waterPercentage =>
      waterGoal.value == 0 ? 0 : waterDrank.value / waterGoal.value;

  double get streakPercentage =>
      streakGoal.value == 0 ? 0 : streakDay.value / streakGoal.value;

  void incrementWater({required int water}) {
    waterDrank.value = waterDrank.value + water;
    databaseService.updateDailyGoal(2, waterDrank.value);
    debugPrint("update of drank successfully completed");
    databaseService.printd();
  }

  void resetWater() {
    waterDrank.value = 0;
    databaseService.updateDailyGoal(2, waterDrank.value);
    debugPrint("drank deleted");
    databaseService.printd();
  }

  void updateGoal(int newGoal) {
    waterGoal.value = newGoal;
    waterDrank.value = 0;
  }

  Future<void> addDailyGoal() async {
    DateTime date = DateTime.now();
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null || dripList.isEmpty) {
      await databaseService.addRow("daily_goal", 2500);
      await databaseService.addRow("drank_water", 0);
      await databaseService.addRow("streak", 0);
      await databaseService.addRow("last_updated", date.toIso8601String());
    }
  }

  void updateDailyGoal() {
    final String dailyGoalString = goalController.text;
    if (dailyGoalString == "") return;
    final int dailyGoal = int.parse(dailyGoalString);

    databaseService.updateDailyGoal(1, dailyGoal);
    waterGoal.value = dailyGoal;
    goalController.clear();
    debugPrint("update completed successfuly");
  }

  Future<void> _loadWaterGoal() async {
    final List<Drip>? dripList = await databaseService.getDrip();

    if (dripList != null && dripList.isNotEmpty) {
      final Drip ilkDrip = dripList.first;

      debugPrint(ilkDrip.id.toString());
      debugPrint(ilkDrip.key);
      debugPrint(ilkDrip.content.toString());

      waterGoal.value = int.tryParse(ilkDrip.content.toString())!;
    }
  }

  Future<void> _loadDrankWater() async {
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList != null && dripList.length > 1) {
      final Drip secondDrip = dripList[1];

      debugPrint(secondDrip.id.toString());
      debugPrint(secondDrip.key);
      debugPrint(secondDrip.content.toString());

      waterDrank.value = int.tryParse(secondDrip.content.toString())!;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, String> getRandomQuote(List<Map<String, String>> quotes) {
    final random = Random();
    int randomIndex = random.nextInt(quotes.length);
    return quotes[randomIndex];
  }

  void drinkWater(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
          child: AlertDialog(
            title: const Text("Add Water"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => RadioListTile<int>(
                    value: waterValue.value,
                    groupValue: selectedWaterML.value,
                    onChanged: (value) {
                      selectedWaterML.value = value!;
                      waterValue.value = int.tryParse(
                        waterValueController.text,
                      )!;
                      debugPrint(value.toString());
                    },
                    title: TextFormField(
                      controller: waterValueController,
                      decoration: InputDecoration(
                        suffix: const Text(
                          " mL",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        debugPrint(
                          "Text Field instant ${waterValueController.text}",
                        );
                      },
                    ),
                    subtitle: const Text(
                      "Select custom value (mL)",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => RadioListTile<int>(
                    value: 150,
                    groupValue: selectedWaterML.value,
                    onChanged: (value) {
                      selectedWaterML.value = value!;
                      debugPrint(value.toString());
                    },
                    title: const Text(
                      "Small Water/Tea Glass",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    subtitle: const Text(
                      "~150mL",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => RadioListTile<int>(
                    value: 200,
                    groupValue: selectedWaterML.value,
                    onChanged: (value) {
                      selectedWaterML.value = value!;
                      debugPrint(value.toString());
                    },
                    title: const Text(
                      "Regular Water Glass",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    subtitle: const Text(
                      "~200mL",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => RadioListTile<int>(
                    value: 500,
                    groupValue: selectedWaterML.value,
                    onChanged: (value) {
                      selectedWaterML.value = value!;
                      debugPrint(value.toString());
                    },
                    title: const Text(
                      "Jumbo Water Glass",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    subtitle: const Text(
                      "~500mL",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  waterValueController.text = "0";
                  selectedWaterML.value = 200;
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  debugPrint(
                    "The water gonna be added: ${selectedWaterML.value.toString()}",
                  );
                  incrementWater(water: selectedWaterML.value);
                  waterValueController.text = "0";
                  selectedWaterML.value = 200;
                  Get.back();
                },
                child: const Text(
                  "Add",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkForStreak() async {
    await databaseService.ensureTodayDrankExist();
    debugPrint("we are sure that there is a row for today");
    final List<Drip>? dripList = await databaseService.getDrip();
    final dripThird = dripList!.firstWhere((e) => e.key == "last_updated");
    final DateTime today = DateTime.now();
    final DateTime? lastUpdated = DateTime.tryParse(
      dripThird.content.toString(),
    );
    if (lastUpdated == null) return;
    final diff = today.difference(lastUpdated).inDays;
    if (diff == 2) {
      debugPrint("One missing day");
    } else {
      debugPrint("No problem for now");
    }
  }

  @override
  void onClose() {
    super.onClose();
    waterValueController.dispose();
    goalController.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    await _initData();

    await checkForStreak();
  }

  Future<void> _initData() async {
    randomQuote = getRandomQuote(motivationalQuotes);
    await addDailyGoal();
    await _loadWaterGoal();
    await _loadDrankWater();
    databaseService.printd();
  }
}
