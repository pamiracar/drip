import 'package:drip/app_routes.dart';
import 'package:drip/pages/home_page/home_page.dart';
import 'package:drip/pages/home_page/home_page_binding.dart';
import 'package:drip/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drip',
      initialRoute: AppRoutes.HOME,
      getPages: [
        GetPage(name: AppRoutes.HOME, page:() => HomePage(), binding: HomePageBinding()),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
