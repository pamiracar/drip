// ignore_for_file: unused_local_variable, unnecessary_nullable_for_final_variable_declarations

import 'dart:math';

import 'package:drip/models/drip.dart';
import 'package:drip/models/water.dart';
import 'package:drip/quotes.dart';
import 'package:drip/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    final DateTime todayDateTime = DateTime.now();
    final String today = DateFormat("yyyy-MM-dd").format(todayDateTime);
    waterDrank.value = waterDrank.value + water;
    databaseService.updateDrankWater(today, waterDrank.value);
    debugPrint("update of drank successfully completed");
    databaseService.printd();
  }

  void resetWater() {
    final String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    waterDrank.value = 0;
    databaseService.updateDrankWater(today, waterDrank.value);
    databaseService.updateDailyGoal(4, today);
    debugPrint("drank deleted");
    databaseService.printd();
  }

  void updateGoal(int newGoal) {
    waterGoal.value = newGoal;
    waterDrank.value = 0;
  }

  Future<void> addDailyGoal() async {
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null || dripList.isEmpty) {
      await databaseService.addRow("daily_goal", 2500);
      await databaseService.addRow("drank_water", 0);
      await databaseService.addRow("streak", 0);
      await databaseService.addRow("last_updated", date);
    }
  }

  void updateDailyGoal() {
    final String dailyGoalString = goalController.text;
    if (dailyGoalString.isEmpty || int.tryParse(dailyGoalString) == null)
      return;
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

  Future<void> _loadStreak() async {
    final List<Drip>? dripList = await databaseService.getDrip();

    if (dripList != null && dripList.isNotEmpty) {
      final Drip thirdDrip = dripList[2];
      streakGoal.value = int.tryParse(thirdDrip.content.toString())!;
    }
  }

  Future<void> _loadDrankWater() async {
    final List<Water>? waterList = await databaseService.getWater();
    final String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final List<Water> filteredList = waterList!
        .where((element) => element.key == today)
        .toList();
    final Water todayWater = filteredList.first;
    waterDrank.value = todayWater.content;
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
    final List<Water>? waterList = await databaseService.getWater();
    final dripThird = dripList!.firstWhere((e) => e.key == "last_updated");
    final String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final String lastUpdatedString = dripThird.content.toString();
    final DateTime? todayDateTime = DateTime.tryParse(today);
    final DateTime? lastUpdated = DateTime.tryParse(
      dripThird.content.toString(),
    );
    final diff = todayDateTime?.difference(lastUpdated!).inDays;
    final String yesterday = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now().subtract(Duration(days: 1)));
    final List<Water> filteredList = waterList!
        .where((element) => element.key == yesterday)
        .toList();
    if (filteredList.isEmpty || diff! >= 2) {
      debugPrint("Dünkü veri yok");

      streakDay.value = 0;
      databaseService.updateDailyGoal(3, streakDay.value);
      debugPrint("Streak reseted!");
      return;
    }
    final Water yesterdayWater = filteredList.first;

    if (lastUpdated == null) return;
    if (diff == 1) {
      debugPrint("One missing day");
      debugPrint("Waterdrank before value = ${waterDrank.value}");
      debugPrint("Update Completed");
      resetWater();
      debugPrint("Water Drank Value: ${waterDrank.value}");
      final int yesterdayWaterConent = int.tryParse(
        yesterdayWater.content.toString(),
      )!;
      if (yesterdayWaterConent >= waterGoal.value) {
        streakDay.value++;
        databaseService.updateDailyGoal(3, streakDay.value);
        debugPrint("StreakUpdated: ${streakDay.value}");
        databaseService.updateDailyGoal(4, today);
      } else {
        streakDay.value = 0;
        databaseService.updateDailyGoal(3, streakDay.value);
        debugPrint("Streak reseted!");
      }
    } else if (diff! >= 2) {
      streakDay.value = 0;
      databaseService.updateDailyGoal(3, streakDay.value);
      debugPrint("Streak reseted!");
    } else {
      debugPrint("No problem for now");
      debugPrint("today = $todayDateTime");
      debugPrint("last updated = $lastUpdated");
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
    await _loadStreak();
  }

  Future<void> _initData() async {
    randomQuote = getRandomQuote(motivationalQuotes);
    await addDailyGoal();
    await checkForStreak();
    await _loadWaterGoal();
    await _loadDrankWater();
    databaseService.printd();
  }
}
