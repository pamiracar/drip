// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:drip/models/drip.dart';
import 'package:drip/quotes.dart';
import 'package:drip/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:path/path.dart';

class HomePageController extends GetxController {
  RxInt waterGoal = 12.obs;
  RxInt waterDrank = 0.obs;
  TextEditingController goalController = TextEditingController();
  TextEditingController waterValueController = TextEditingController();
  final DatabaseService databaseService = DatabaseService.instance;
  RxInt streakDay = 0.obs;
  RxInt streakGoal = 10.obs;
  RxInt selectedWaterML = 220.obs;


  double get waterPercentage =>
      waterGoal.value == 0 ? 0 : waterDrank.value / waterGoal.value;

  double get streakPercentage =>
      streakGoal.value == 0 ? 0 : streakDay.value / streakGoal.value;

  void incrementWater() {
    if (waterDrank.value < waterGoal.value) {
      waterDrank.value++;
      databaseService.updateDailyGoal(2, waterDrank.value);
      debugPrint("update of drank successfully completed");
      databaseService.printd();
    }
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
    String date =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null || dripList.isEmpty) {
      await databaseService.addRow("daily_goal", 12);
      await databaseService.addRow("drank_water", 0);
      await databaseService.addRow("streak", 0);
      await databaseService.addRow("last_updated", date);
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

  Future<void> _loadStreak() async {
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList != null && dripList.length > 1) {
      final Drip thirdDrip = dripList[2];
      streakDay.value = int.tryParse(thirdDrip.content.toString())!;
    }
  }

  Future<void> checkStreakStatus() async {
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null || dripList.isEmpty) return;

    int drank = 0;
    int goal = 0;
    int streak = 0;
    DateTime? lastUpdated;

    for (var drip in dripList) {
      if (drip.key == "drank_water") {
        drank = int.tryParse(drip.content.toString()) ?? 0;
      } else if (drip.key == "daily_goal") {
        goal = int.tryParse(drip.content.toString()) ?? 0;
      } else if (drip.key == "streak") {
        streak = int.tryParse(drip.content.toString()) ?? 0;
      } else if (drip.key == "last_updated") {
        lastUpdated = DateTime.tryParse(drip.content.toString());
      }
    }

    final DateTime today = DateTime.now();
    final DateTime yesterday = today.subtract(Duration(days: 1));
    final String todayString =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

    if (lastUpdated == null) {
      if (drank >= goal) {
        streakDay.value = 1;
        await databaseService.updateDailyGoal(3, 1);
        await databaseService.updateDailyGoal(4, todayString);
      }
      return;
    }

    if (isSameDay(lastUpdated, today)) {
      streakDay.value = streak;
    }

    if (isSameDay(lastUpdated, yesterday) && drank >= goal) {
      streakDay.value = streak + 1;
    } else {
      streakDay.value = 0;
    }

    await databaseService.updateDailyGoal(3, streakDay.value);
    await databaseService.updateDailyGoal(4, todayString);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, String> getRandomQuote(List<Map<String, String>> quotes) {
    final random = Random();
    int randomIndex = random.nextInt(quotes.length);
    return quotes[randomIndex];
  }

  Future<void> resetIfNeeded() async {
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null) return;

    DateTime? lastUpdated;
    int drank = 0;
    int goal = 0;

    for (var drip in dripList) {
      if (drip.key == "last_updated") {
        lastUpdated = DateTime.tryParse(drip.content.toString());
      } else if (drip.key == "drank_water") {
        drank = int.tryParse(drip.content.toString()) ?? 0;
      } else if (drip.key == "daily_goal") {
        goal = int.tryParse(drip.content.toString()) ?? 0;
      }
    }

    final DateTime today = DateTime.now();
    final DateTime yesterday = today.subtract(Duration(days: 1));
    final String todayString = "${today.year}-${today.month}-${today.day}";

    if (lastUpdated == null) return;

    if (isSameDay(lastUpdated, today)) return;

    if (isSameDay(lastUpdated, yesterday) && drank >= goal) {
      streakDay.value++;
    } else {
      streakDay.value = 0;
    }

    waterDrank.value = 0;
    await databaseService.updateDailyGoal(2, 0);
    await databaseService.updateDailyGoal(3, streakDay.value);
    await databaseService.updateDailyGoal(4, todayString);
  }

  Map<String, String>? randomQuote;

  int? waterValue = 0;


  void drinkWater(BuildContext context) {
    incrementWater();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
      title: const Text("Add Water"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => RadioListTile<int>(
              value: 100,
              groupValue: selectedWaterML.value,
              onChanged: (value) => selectedWaterML.value = value!,
              title: const Text(
                "Small Water Glass",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              subtitle: const Text(
                "~100mL",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Obx(
            () => RadioListTile<int>(
              value:220,
              groupValue: selectedWaterML.value,
              onChanged: (value) => selectedWaterML.value = value!,
              title: const Text(
                "Regular Water Glass",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              subtitle: const Text(
                "~220mL",
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
              onChanged: (value) => selectedWaterML.value = value!,
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
          Obx(
            () => RadioListTile<int>(
              value:waterValue,
              groupValue: selectedWaterML.value,
              onChanged: (value) {
                selectedWaterML.value = value!;
                waterValue = int.tryParse(waterValueController.text);
                debugPrint(value.toString());
              },
              title: TextFormField(
                controller: waterValueController,
                decoration: InputDecoration(
                  suffix: const Text(" mL")
                ),
                keyboardType: TextInputType.number,
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
        ],
      ),
    );
      },
    );
  }

  @override
  void onInit() async {
    super.onInit();
    await _initData();
    await resetIfNeeded();
  }

  Future<void> _initData() async {
    randomQuote = getRandomQuote(motivationalQuotes);
    await addDailyGoal();
    await _loadWaterGoal();
    await _loadDrankWater();
    await _loadStreak();
    databaseService.printd();
  }
}
