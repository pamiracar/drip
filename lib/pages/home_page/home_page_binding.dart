import 'package:drip/pages/home_page/home_page_controller.dart';
import 'package:get/instance_manager.dart';

class HomePageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController(),);
  }
}
