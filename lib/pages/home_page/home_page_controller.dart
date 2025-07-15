import 'package:drip/models/task.dart';
import 'package:drip/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomePageController extends GetxController {
  RxInt waterGoal = 12.obs;
  RxInt waterDrank = 0.obs;
  TextEditingController goalController = TextEditingController();
  final DatabaseService databaseService = DatabaseService.instance;

  double get waterPercentage =>
      waterGoal.value == 0 ? 0 : waterDrank.value / waterGoal.value;

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
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList == null || dripList.isEmpty) {
      await databaseService.addRow("daily_goal", 12);
      await databaseService.addRow("drank_water", 0);
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

      waterGoal.value = ilkDrip.content;
    }
  }

  Future<void> _loadDrankWater() async {
    final List<Drip>? dripList = await databaseService.getDrip();
    if (dripList != null && dripList.length > 1) {
      final Drip secondDrip = dripList[1];

      debugPrint(secondDrip.id.toString());
      debugPrint(secondDrip.key);
      debugPrint(secondDrip.content.toString());

      waterDrank.value = secondDrip.content;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await _initData();
  }

  Future<void> _initData() async {
    await addDailyGoal();
    await _loadWaterGoal();
    await _loadDrankWater();
    databaseService.printd();
  }
}
