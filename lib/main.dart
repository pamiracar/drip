import 'package:drip/app_routes.dart';
import 'package:drip/pages/home_page/home_page.dart';
import 'package:drip/pages/home_page/home_page_binding.dart';
import 'package:drip/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ScreenUtilInit(
      designSize: Size(430, 932),
      builder: (context, child) {
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drip',
      initialRoute: AppRoutes.HOME,
      getPages: [
        GetPage(
          name: AppRoutes.HOME,
          page: () => HomePage(),
          binding: HomePageBinding(),
        ),
      ],
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
