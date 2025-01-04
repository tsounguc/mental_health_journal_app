import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/resources/fonts.dart';
import 'package:mental_health_journal_app/core/services/router/router.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';

void main() async {
  await setUpServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.poppins,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
