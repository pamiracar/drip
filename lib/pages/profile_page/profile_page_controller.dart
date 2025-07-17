import 'dart:math';

import 'package:drip/quotes.dart';
import 'package:drip/services/db_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/state_manager.dart';

class ProfilePageController extends GetxController {
  var waterData = <FlSpot>[].obs;
  final DatabaseService databaseService = DatabaseService.instance;
  Map<String, String>? randomQuote;

  @override
  void onInit() {
    super.onInit();
    loadWaterData();
    randomQuote = getRandomQuote(motivationalQuotes);
  }

  Future<void> loadWaterData() async {
    final rawData = await databaseService.getLast7DaysNormalizedWater();

    waterData.value = List.generate(rawData.length, (index) {
      return FlSpot(index.toDouble(), rawData[index]["amount"]);
    });
  }

  Map<String, String> getRandomQuote(List<Map<String, String>> quotes) {
    final random = Random();
    int randomIndex = random.nextInt(quotes.length);
    return quotes[randomIndex];
  }
}
