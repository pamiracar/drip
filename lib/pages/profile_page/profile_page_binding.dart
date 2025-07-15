import 'package:drip/pages/profile_page/profile_page_controller.dart';
import 'package:get/get.dart';

class ProfilePageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfilePageController(),);
  }
}
