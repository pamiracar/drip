import 'package:drip/pages/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          children: [
            const Text("Home Page"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Home Page"),
                    const Text("Home Page"),
                    const Text("Home Page"),
                    const Text("Home Page"),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Home Page")),
            TextFormField(
              decoration: InputDecoration(
                hint: const Text("h"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
