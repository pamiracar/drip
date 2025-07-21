// ignore_for_file: unused_local_variable, unnecessary_nullable_for_final_variable_declarations

import 'dart:math';

import 'package:drip/models/drip.dart';
import 'package:drip/models/water.dart';
import 'package:drip/quotes.dart';
import 'package:drip/services/db_service.dart';
import 'package:drip/services/noti_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void requestNotificationPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isRestricted ||
      await Permission.notification.isLimited) {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      debugPrint("🔔 Bildirim izni verildi");
    } else {
      debugPrint("❌ Bildirim izni reddedildi");
    }
  } else {
    debugPrint("✅ Bildirim izni zaten verilmiş");
  }
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
    if (dailyGoalString.isEmpty || int.tryParse(dailyGoalString) == null) {
      return;
    }
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

                        selectedWaterML.value = int.tryParse(waterValueController.text.toString())!;
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
  }

  Future<void> notiButton() async {
    NotiServices().scheduleNotification(title: "Good Morning", body: "Lets start drinking water", hour: 9, minute: 30);
    NotiServices().scheduleNotification(title: "This is the end of the day", body: "The day is ending. Finish it.", hour: 18, minute: 00);
    NotiServices().scheduleNotification(title: "Good Night!", body: "Have a good night", hour: 23, minute: 00);
    debugPrint("scheduled notifi");
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
    randomQuote = getRandomQuote(motivationalQuotes);
    await checkForStreak();
    await _initData();
    await _loadStreak();
    requestNotificationPermission();
  }

  Future<void> _initData() async {
    await addDailyGoal();
    await checkForStreak();
    await _loadWaterGoal();
    await _loadDrankWater();
    await notiButton();
    databaseService.printd();
  }
}
